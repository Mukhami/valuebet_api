defmodule ValuebetApiWeb.GameController do
  use ValuebetApiWeb, :controller

  alias ValuebetApi.GameManagement
  alias ValuebetApi.GameManagement.Game

  action_fallback ValuebetApiWeb.FallbackController

  def index(conn, _params) do
    games = GameManagement.list_games()
    render(conn, :index, games: games)
  end

  def create(conn, %{"game" => game_params}) do
    with {:ok, %Game{} = game} <- GameManagement.create_game(game_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~s("/api/games/#{game.id}"))
      |> render(:show, game: game)
    end
  end

  def show(conn, %{"id" => id}) do
    game = GameManagement.get_game!(id)
    render(conn, :show, game: game)
  end

  def update(conn, %{"id" => id, "game" => game_params}) do
    game = GameManagement.get_game!(id)

    with {:ok, %Game{} = game} <- GameManagement.update_game(game, game_params) do
      render(conn, :show, game: game)
    end
  end

  def delete(conn, %{"id" => id}) do
    game = GameManagement.get_game!(id)

    with {:ok, %Game{}} <- GameManagement.delete_game(game) do
      send_resp(conn, :no_content, "")
    end
  end
end
