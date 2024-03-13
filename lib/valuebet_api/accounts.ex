defmodule ValuebetApi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias ValuebetApi.Repo

  alias ValuebetApi.Accounts.User
  alias ValuebetApi.Accounts.Role
  alias ValuebetApi.Accounts.UserRoles

  @doc """
  Returns the list of users.
  Where deleted_at is null

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(from u in User, where: is_nil(u.deleted_at), order_by: [desc: u.id])
    |> Repo.preload(:roles)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    Repo.get!(User, id)
    |> Repo.preload(:roles)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    is_admin = attrs["is_admin"]

    IO.puts(is_admin)

    user_changeset =
      %User{}
      |> User.changeset(attrs)
      |> Repo.insert()

    case user_changeset do
      {:ok, user} ->
        case is_admin do
          true ->
            case get_role_by_name("admin") do
              %Role{} = role ->
                assign_role_to_user(user, role)
                {:ok, user}

              nil ->
                {:error, :default_role_not_found}
            end

          _ ->
            case get_role_by_name("user") do
              %Role{} = role ->
                assign_role_to_user(user, role)
                {:ok, user}

              nil ->
                {:error, :default_role_not_found}
            end
        end

      _ ->
        user_changeset
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changesetUpdateUser(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    # Repo.delete(user)
    deleted_at = DateTime.utc_now() |> DateTime.truncate(:second)

    user
    |> Ecto.Changeset.change(deleted_at: deleted_at)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  @doc """
  Fetch User based on their email address
  """
  def get_by_email(email) do
    case Repo.get_by(User, email: email) do
      nil ->
        {:error, :user_not_found}

      user ->
        {:ok, user}
    end
  end

  alias ValuebetApi.Accounts.Role

  @doc """
  Returns the list of roles.

  ## Examples

      iex> list_roles()
      [%Role{}, ...]

  """
  def list_roles do
    Repo.all(Role)
  end

  @doc """
  Gets a single role.

  Raises `Ecto.NoResultsError` if the Role does not exist.

  ## Examples

      iex> get_role!(123)
      %Role{}

      iex> get_role!(456)
      ** (Ecto.NoResultsError)

  """
  def get_role!(id), do: Repo.get!(Role, id)

  @doc """
  Creates a role.

  ## Examples

      iex> create_role(%{field: value})
      {:ok, %Role{}}

      iex> create_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_role(attrs \\ %{}) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a role.

  ## Examples

      iex> update_role(role, %{field: new_value})
      {:ok, %Role{}}

      iex> update_role(role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_role(%Role{} = role, attrs) do
    role
    |> Role.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a role.

  ## Examples

      iex> delete_role(role)
      {:ok, %Role{}}

      iex> delete_role(role)
      {:error, %Ecto.Changeset{}}

  """
  def delete_role(%Role{} = role) do
    Repo.delete(role)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking role changes.

  ## Examples

      iex> change_role(role)
      %Ecto.Changeset{data: %Role{}}

  """
  def change_role(%Role{} = role, attrs \\ %{}) do
    Role.changeset(role, attrs)
  end

  @doc """
  Assigns a role to a user.

  ## Examples

      iex> assign_role(user, "admin")
      {:ok, %User{}}

      iex> assign_role(user, "user")
      {:ok, %User{}}

      iex> assign_role(user, "invalid_role")
      {:error, :invalid_role}
  """
  def assign_role(%User{} = user, role_name) do
    case get_role_by_name(role_name) do
      %Role{} = role ->
        {:ok, assign_role_to_user(user, role)}

      nil ->
        {:error, :invalid_role}
    end
  end

  # Helper function to fetch a role by its name
  defp get_role_by_name(role_name) do
    Repo.get_by(Role, name: role_name)
  end

  # Helper function to assign a role to a user
  defp assign_role_to_user(user, role) do
    case Repo.insert(%UserRoles{user_id: user.id, role_id: role.id}) do
      {:ok, _} ->
        {:ok, user}

      _ ->
        {:error, :assignment_failed}
    end
  end
end
