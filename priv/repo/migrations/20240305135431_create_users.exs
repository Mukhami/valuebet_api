defmodule ValuebetApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :msisdn, :string
      add :status, :boolean, default: true, null: false
      add :email, :string
      add :encrypted_password, :string
      timestamps(type: :utc_datetime)
      add :deleted_at, :utc_datetime, default: nil
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:msisdn])
  end
end
