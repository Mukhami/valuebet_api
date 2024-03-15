defmodule ValuebetApiWeb.BetJSON do
  alias ValuebetApi.Accounts.User
  alias ValuebetApi.GameManagement.Game
  alias ValuebetApi.BetManagement.Bet

  @doc """
  Renders a list of bets.
  """
  def index(%{bets: bets}) do
    %{data: for(bet <- bets, do: data(bet))}
  end

  @doc """
  Renders a single bet.
  """
  def show(%{bet: bet}) do
    %{data: data(bet)}
  end

  @doc """
  Renders the bet snapshot data.
  """
  def snapshot(%{snapshot: snapshot}) do
    %{data: snapshot}
  end


  defp data(%Bet{} = bet) do
    %{
      id: bet.id,
      user: user(bet.user),
      game: game(bet.game),
      game_id: bet.game_id,
      user_id: bet.user_id,
      amount: bet.amount,
      selection: bet.selection,
      status: bet.status,
      won: bet.won,
      result_status: bet.result_status,
      winnings: bet.winnings,
      inserted_at: bet.inserted_at
    }
  end

  defp user(nil), do: nil

  defp user(%User{} = user) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      msisdn: user.msisdn
    }
  end

  defp user(_), do: nil

  defp game(nil), do: nil

  defp game(%Game{} = game) do
    %{
      id: game.id,
      result: game.result,
      home_team: game.home_team,
      away_team: game.away_team,
      home_odds: game.home_odds,
      draw_odds: game.draw_odds,
      away_odds: game.away_odds,
      scheduled_at: game.scheduled_at
    }
  end

  defp game(_), do: nil
end
