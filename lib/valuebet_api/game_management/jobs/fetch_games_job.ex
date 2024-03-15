defmodule ValuebetApi.GameManagement.Jobs.FetchGamesJob do
  alias ValuebetApi.Email
  alias ValuebetApi.GameManagement.Jobs.SendEmailJob
  use Oban.Worker, queue: :default, max_attempts: 1

  alias ValuebetApi.Repo
  alias ValuebetApi.GameManagement.Game
  alias ValuebetApi.BetManagement.Bet
  import Ecto.Query, warn: false


  @impl Oban.Worker
  def perform(_args) do
    IO.puts("************************* Fetching games *************************")
    # target time is now plus 5 minutes
    target_time = DateTime.utc_now() |> DateTime.add(5, :minute)

    # Fetch all games scheduled in the next 5 minutes where result is null
    query =
      from(g in Game, where: g.scheduled_at <= ^target_time and is_nil(g.result), select: g)

    games = Repo.all(query)

    IO.inspect(Enum.count(games))

    # Assign a random result to each game
    Enum.each(games, fn game ->
      result = generate_random_result()

      query = from(g in Game, where: g.id == ^game.id)

      Repo.update_all(query, set: [result: result])
      updated_game = Repo.get(Game, game.id)

      case updated_game do
        %Game{} ->
          IO.inspect(updated_game, label: "Game Updated")

          bets_query = from(b in Bet, where: b.game_id == ^game.id)
          bets = Repo.all(bets_query) |> Repo.preload(:user)

          Enum.each(bets, fn bet ->
            if bet.selection == updated_game.result do
              winning_odd = case bet.selection do
                "home_win" -> updated_game.home_odds
                "away_win" -> updated_game.away_odds
                "draw" -> updated_game.draw_odds
              end
              winnings = bet.amount * winning_odd
              Repo.update_all(from(b in Bet, where: b.id == ^bet.id), set: [won: true, winnings: winnings, result_status: "won"])

              deliver(
                bet.user.email,
                "Congratulations! Your bet has won!",
                "Your bet on game #{updated_game.id} has won. Your winnings are #{winnings}."
              )

            else
              Repo.update_all(from(b in Bet, where: b.id == ^bet.id), set: [won: false, winnings: 0.0,  result_status: "lost"])

              deliver(
            bet.user.email,
            "Unfortunately, your bet has lost",
            "Your bet on game #{updated_game.id} has lost. Better luck next time!"
          )
            end
          end)

        _ -> IO.inspect("Error Updating Game")
      end
    end)
  end

  defp generate_random_result() do
    ["home_win", "away_win", "draw"] |> Enum.random()
  end


  defp deliver(recipient, subject, body) do
    email = Email.create_email(recipient, subject, body)

    with email_map <- ValuebetApi.Mailer.to_map(email),
         {:ok, _job} <- enqueue_worker(email_map) do
      {:ok, email}
    end
  end

  defp enqueue_worker(email) do
    %{email: email}
    |> SendEmailJob.new()
    |> Oban.insert()
  end
end
