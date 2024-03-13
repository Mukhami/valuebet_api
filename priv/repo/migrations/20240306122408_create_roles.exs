defmodule ValuebetApi.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :name, :string
      add :description, :text
      timestamps(type: :utc_datetime)
      add :deleted_at, :utc_datetime, default: nil
    end
  end
end
