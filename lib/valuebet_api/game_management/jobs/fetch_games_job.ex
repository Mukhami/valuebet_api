defmodule ValuebetApi.GameManagement.Jobs.FetchGamesJob do
  use Oban.Worker, queue: :default, max_attempts: 1

  alias ValuebetApi.Repo
  alias ValuebetApi.GameManagement.Game
  alias ValuebetApi.BetManagement.Bet
  import Ecto.Query, warn: false

  @impl Oban.Worker
  def perform(_args) do
    IO.puts("Fetching games...")
    # target time is now plus 5 minutes
    target_time = DateTime.utc_now() |> DateTime.add(5, :minute)

    # Fetch all games scheduled in the next 5 minutes where result is null
    query =
      from(g in Game, where: g.scheduled_at <= ^target_time and is_nil(g.result), select: g)

    games = Repo.all(query)

    IO.puts("Games Found: ")

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
          bets = Repo.all(bets_query)

          Enum.each(bets, fn bet ->
            if bet.selection == updated_game.result do
              Repo.update_all(from(b in Bet, where: b.id == ^bet.id), set: [won: true])
            else
              Repo.update_all(from(b in Bet, where: b.id == ^bet.id), set: [won: false])
            end
          end)

        _ -> IO.inspect("Error Updating Game")
      end
    end)
  end

  defp generate_random_result() do
    ["home_win", "away_win", "draw"] |> Enum.random()
  end
end
