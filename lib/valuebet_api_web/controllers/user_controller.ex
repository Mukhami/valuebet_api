defmodule ValuebetApiWeb.UserController do
  use ValuebetApiWeb, :controller

  alias ValuebetApi.Accounts
  alias ValuebetApi.Accounts.User
  alias ValuebetApiWeb.Auth.Guardian
  alias ValuebetApi.Repo

  action_fallback ValuebetApiWeb.FallbackController

  def login(conn, %{"email" => email, "password" => password}) do
    with {:ok, user, token} <- Guardian.authenticate(email, password) do
      user = Repo.preload(user, :roles)

      conn
      |> put_status(:created)
      |> render(:auth, %{user: user, token: token})
    end
  end

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  def register(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      user = Repo.preload(user, :roles)

      conn
      |> put_status(:created)
      |> render(:auth, %{user: user, token: token})
    end
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      user = Repo.preload(user, :roles)

      conn
      |> put_status(:created)
      |> render(:show, user: user)
    end
  end

  def profile(conn, _params) do
    case get_token_from_headers(conn) do
      {:ok, token} ->
        with {:ok, claims} <- Guardian.decode_and_verify(token),
             {:ok, user} <- Guardian.resource_from_claims(claims) do
          user = Repo.preload(user, :roles)
          render(conn, :profile, user: user)
        else
          _ ->
            send_resp(conn, :unauthorized, "Invalid token")
        end

      {:error, _reason} ->
        send_resp(conn, :unauthorized, "Token not provided")
    end
  end

  defp get_token_from_headers(conn) do
    case get_req_header(conn, "authorization") do
      [token | _] -> {:ok, token}
      _ -> {:error, :token_not_found}
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
