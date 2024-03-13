defmodule ValuebetApi.GameManagementFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ValuebetApi.GameManagement` context.
  """

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{
        away_odds: 120.5,
        away_team: "some away_team",
        draw_odds: 120.5,
        home_odds: 120.5,
        home_team: "some home_team",
        result: "some result",
        scheduled_at: ~U[2024-03-04 12:27:00Z]
      })
      |> ValuebetApi.GameManagement.create_game()

    game
  end
end
