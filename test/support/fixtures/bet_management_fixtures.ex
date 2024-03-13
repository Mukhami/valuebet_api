defmodule ValuebetApi.BetManagementFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ValuebetApi.BetManagement` context.
  """

  @doc """
  Generate a bet.
  """
  def bet_fixture(attrs \\ %{}) do
    {:ok, bet} =
      attrs
      |> Enum.into(%{
        amount: 120.5,
        selection: "some selection",
        status: true
      })
      |> ValuebetApi.BetManagement.create_bet()

    bet
  end
end
