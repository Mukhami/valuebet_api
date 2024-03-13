defmodule ValuebetApi.Accounts.User do
  alias ValuebetApi.Repo
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias ValuebetApi.Accounts.User

  schema "users" do
    field :status, :boolean, default: true
    field :encrypted_password, :string
    field :password, :string, virtual: true
    field :first_name, :string
    field :last_name, :string
    field :msisdn, :string
    field :email, :string
    field :deleted_at, :utc_datetime, default: nil
    timestamps(type: :utc_datetime)

    many_to_many :roles, ValuebetApi.Accounts.Role, join_through: "user_roles"
  end

  @doc false
  def changesetUpdateUser(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :msisdn, :email, :status])
    |> validate_required([:first_name, :last_name, :msisdn, :email])
    |> is_unique_email()
    |> is_unique_msisdn()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :msisdn, :email, :password])
    |> validate_required([:first_name, :last_name, :msisdn, :email, :password])
    |> validate_length(:password, min: 8)
    |> is_unique_email()
    |> is_unique_msisdn()
    |> put_hashed_password
  end

  defp put_hashed_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))

      _ ->
        changeset
    end
  end

  defp is_unique_email(changeset) do
    case get_change(changeset, :email) do
      nil ->
        changeset

      email ->
        case Repo.get_by(User, email: email) do
          nil -> changeset
          _ -> add_error(changeset, :email, "has already been taken")
        end
    end
  end

  defp is_unique_msisdn(changeset) do
    case get_change(changeset, :msisdn) do
      nil ->
        changeset

      msisdn ->
        case Repo.get_by(User, msisdn: msisdn) do
          nil -> changeset
          _ -> add_error(changeset, :msisdn, "has already been taken")
        end
    end
  end
end
