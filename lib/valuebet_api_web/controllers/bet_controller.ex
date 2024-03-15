defmodule ValuebetApiWeb.BetController do
  use ValuebetApiWeb, :controller

  alias ValuebetApi.BetManagement
  alias ValuebetApi.BetManagement.Bet

  action_fallback ValuebetApiWeb.FallbackController

  def index(conn, _params) do
    bets = BetManagement.list_bets()
    render(conn, :index, bets: bets)
  end

  def user_index(conn, %{"user_id" => user_id}) do
    bets = BetManagement.list_bets_for_user(user_id)
    render(conn, :index, bets: bets)
  end

  def create(conn, %{"bet" => bet_params}) do
    with {:ok, %Bet{} = bet} <- BetManagement.create_bet(bet_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/bets/#{bet}")
      |> render(:show, bet: bet)
    end
  end

  def show(conn, %{"id" => id}) do
    bet = BetManagement.get_bet!(id)
    render(conn, :show, bet: bet)
  end

  def update(conn, %{"id" => id, "bet" => bet_params}) do
    bet = BetManagement.get_bet!(id)

    with {:ok, %Bet{} = bet} <- BetManagement.update_bet(bet, bet_params) do
      render(conn, :show, bet: bet)
    end
  end

  def delete(conn, %{"id" => id}) do
    bet = BetManagement.get_bet!(id)

    with {:ok, %Bet{}} <- BetManagement.delete_bet(bet) do
      send_resp(conn, :no_content, "")
    end
  end

  def fetch_bet_snapshot(conn, _params) do
    snapshot = BetManagement.fetch_bet_snapshpot()
    render(conn, :snapshot, snapshot: snapshot)
  end

end
