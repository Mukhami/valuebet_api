defmodule ValuebetApiWeb.UserJSON do
  alias ValuebetApi.Accounts.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  @doc """
    Auth response that has a user and access token
  """
  def auth(%{user: user, token: token}) do
    %{data: data(user), access_token: token}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      msisdn: user.msisdn,
      status: user.status,
      email: user.email,
      roles: roles(user.roles),
      inserted_at: user.inserted_at,
      updated_at: user.updated_at,
      deleted_at: user.deleted_at
    }
  end

  defp roles(nil), do: []

  defp roles(roles) do
    for role <- roles, into: [], do: role.name
  end
end
