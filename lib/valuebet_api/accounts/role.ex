defmodule ValuebetApi.Accounts.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :name, :string
    field :description, :string, default: nil
    field :deleted_at, :utc_datetime, default: nil
    timestamps(type: :utc_datetime)

    many_to_many :users, ValuebetApi.Accounts.User, join_through: "user_roles"
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
  end
end
