defmodule ValuebetApi.GameManagementTest do
  use ValuebetApi.DataCase

  alias ValuebetApi.GameManagement

  describe "games" do
    alias ValuebetApi.GameManagement.Game

    import ValuebetApi.GameManagementFixtures

    @invalid_attrs %{
      result: nil,
      home_team: nil,
      away_team: nil,
      home_odds: nil,
      draw_odds: nil,
      away_odds: nil,
      scheduled_at: nil
    }

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert GameManagement.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert GameManagement.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      valid_attrs = %{
        result: "some result",
        home_team: "some home_team",
        away_team: "some away_team",
        home_odds: 120.5,
        draw_odds: 120.5,
        away_odds: 120.5,
        scheduled_at: ~U[2024-03-04 12:27:00Z]
      }

      assert {:ok, %Game{} = game} = GameManagement.create_game(valid_attrs)
      assert game.result == "some result"
      assert game.home_team == "some home_team"
      assert game.away_team == "some away_team"
      assert game.home_odds == 120.5
      assert game.draw_odds == 120.5
      assert game.away_odds == 120.5
      assert game.scheduled_at == ~U[2024-03-04 12:27:00Z]
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = GameManagement.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()

      update_attrs = %{
        result: "some updated result",
        home_team: "some updated home_team",
        away_team: "some updated away_team",
        home_odds: 456.7,
        draw_odds: 456.7,
        away_odds: 456.7,
        scheduled_at: ~U[2024-03-05 12:27:00Z]
      }

      assert {:ok, %Game{} = game} = GameManagement.update_game(game, update_attrs)
      assert game.result == "some updated result"
      assert game.home_team == "some updated home_team"
      assert game.away_team == "some updated away_team"
      assert game.home_odds == 456.7
      assert game.draw_odds == 456.7
      assert game.away_odds == 456.7
      assert game.scheduled_at == ~U[2024-03-05 12:27:00Z]
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = GameManagement.update_game(game, @invalid_attrs)
      assert game == GameManagement.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = GameManagement.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> GameManagement.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = GameManagement.change_game(game)
    end
  end
end
