defmodule ValuebetApiWeb.GameControllerTest do
  use ValuebetApiWeb.ConnCase

  import ValuebetApi.GameManagementFixtures

  alias ValuebetApi.GameManagement.Game

  @create_attrs %{
    result: "some result",
    home_team: "some home_team",
    away_team: "some away_team",
    home_odds: 120.5,
    draw_odds: 120.5,
    away_odds: 120.5,
    scheduled_at: ~U[2024-03-04 12:27:00Z]
  }
  @update_attrs %{
    result: "some updated result",
    home_team: "some updated home_team",
    away_team: "some updated away_team",
    home_odds: 456.7,
    draw_odds: 456.7,
    away_odds: 456.7,
    scheduled_at: ~U[2024-03-05 12:27:00Z]
  }
  @invalid_attrs %{
    result: nil,
    home_team: nil,
    away_team: nil,
    home_odds: nil,
    draw_odds: nil,
    away_odds: nil,
    scheduled_at: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all games", %{conn: conn} do
      conn = get(conn, ~p"/api/games")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create game" do
    test "renders game when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/games", game: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/games/#{id}")

      assert %{
               "id" => ^id,
               "away_odds" => 120.5,
               "away_team" => "some away_team",
               "draw_odds" => 120.5,
               "home_odds" => 120.5,
               "home_team" => "some home_team",
               "result" => "some result",
               "scheduled_at" => "2024-03-04T12:27:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/games", game: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update game" do
    setup [:create_game]

    test "renders game when data is valid", %{conn: conn, game: %Game{id: id} = game} do
      conn = put(conn, ~p"/api/games/#{game}", game: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/games/#{id}")

      assert %{
               "id" => ^id,
               "away_odds" => 456.7,
               "away_team" => "some updated away_team",
               "draw_odds" => 456.7,
               "home_odds" => 456.7,
               "home_team" => "some updated home_team",
               "result" => "some updated result",
               "scheduled_at" => "2024-03-05T12:27:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, game: game} do
      conn = put(conn, ~p"/api/games/#{game}", game: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete game" do
    setup [:create_game]

    test "deletes chosen game", %{conn: conn, game: game} do
      conn = delete(conn, ~p"/api/games/#{game}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/games/#{game}")
      end
    end
  end

  defp create_game(_) do
    game = game_fixture()
    %{game: game}
  end
end
