defmodule ValuebetApiWeb.GameJSON do
  alias ValuebetApi.GameManagement.Game

  @doc """
  Renders a list of games.
  """
  def index(%{games: games}) do
    %{data: for(game <- games, do: data(game))}
  end

  @doc """
  Renders a single game.
  """
  def show(%{game: game}) do
    %{data: data(game)}
  end

  defp data(%Game{} = game) do
    %{
      id: game.id,
      home_team: game.home_team,
      away_team: game.away_team,
      home_odds: game.home_odds,
      draw_odds: game.draw_odds,
      away_odds: game.away_odds,
      result: game.result,
      scheduled_at: game.scheduled_at,
      inserted_at: game.inserted_at
    }
  end
end
