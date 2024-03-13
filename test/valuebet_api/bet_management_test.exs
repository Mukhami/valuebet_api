defmodule ValuebetApi.BetManagementTest do
  use ValuebetApi.DataCase

  alias ValuebetApi.BetManagement

  describe "bets" do
    alias ValuebetApi.BetManagement.Bet

    import ValuebetApi.BetManagementFixtures

    @invalid_attrs %{status: nil, amount: nil, selection: nil}

    test "list_bets/0 returns all bets" do
      bet = bet_fixture()
      assert BetManagement.list_bets() == [bet]
    end

    test "get_bet!/1 returns the bet with given id" do
      bet = bet_fixture()
      assert BetManagement.get_bet!(bet.id) == bet
    end

    test "create_bet/1 with valid data creates a bet" do
      valid_attrs = %{status: true, amount: 120.5, selection: "some selection"}

      assert {:ok, %Bet{} = bet} = BetManagement.create_bet(valid_attrs)
      assert bet.status == true
      assert bet.amount == 120.5
      assert bet.selection == "some selection"
    end

    test "create_bet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = BetManagement.create_bet(@invalid_attrs)
    end

    test "update_bet/2 with valid data updates the bet" do
      bet = bet_fixture()
      update_attrs = %{status: false, amount: 456.7, selection: "some updated selection"}

      assert {:ok, %Bet{} = bet} = BetManagement.update_bet(bet, update_attrs)
      assert bet.status == false
      assert bet.amount == 456.7
      assert bet.selection == "some updated selection"
    end

    test "update_bet/2 with invalid data returns error changeset" do
      bet = bet_fixture()
      assert {:error, %Ecto.Changeset{}} = BetManagement.update_bet(bet, @invalid_attrs)
      assert bet == BetManagement.get_bet!(bet.id)
    end

    test "delete_bet/1 deletes the bet" do
      bet = bet_fixture()
      assert {:ok, %Bet{}} = BetManagement.delete_bet(bet)
      assert_raise Ecto.NoResultsError, fn -> BetManagement.get_bet!(bet.id) end
    end

    test "change_bet/1 returns a bet changeset" do
      bet = bet_fixture()
      assert %Ecto.Changeset{} = BetManagement.change_bet(bet)
    end
  end
end
