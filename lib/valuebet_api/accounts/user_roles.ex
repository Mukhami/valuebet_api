defmodule ValuebetApi.Accounts.UserRoles do
  use Ecto.Schema

  schema "user_roles" do
    belongs_to :user, ValuebetApi.Accounts.User
    belongs_to :role, ValuebetApi.Accounts.Role
    timestamps(type: :utc_datetime)
  end
end
