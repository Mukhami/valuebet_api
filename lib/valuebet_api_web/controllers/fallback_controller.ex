defmodule ValuebetApiWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use ValuebetApiWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: ValuebetApiWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: ValuebetApiWeb.ErrorHTML, json: ValuebetApiWeb.ErrorJSON)
    |> render(:"404")
  end

  # This clause is an example of how to handle invalid credentials.
  def call(conn, {:error, :user_not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: ValuebetApiWeb.ErrorHTML, json: ValuebetApiWeb.ErrorJSON)
    |> render(:"400")
  end

  # # This clause handles the :secret_not_found error
  # def call(conn, {:error, :secret_not_found}) do
  #   conn
  #   |> put_status(:internal_server_error)
  #   |> put_view(html: ValuebetApiWeb.ErrorHTML, json: ValuebetApiWeb.ErrorJSON)
  #   |> render(:"500")
  # end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(html: ValuebetApiWeb.ErrorHTML, json: ValuebetApiWeb.ErrorJSON)
    |> render(:"401")
  end
end
