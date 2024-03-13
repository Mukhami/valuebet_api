defmodule ValuebetApi.Repo.Migrations.CreateBets do
  use Ecto.Migration

  def change do
    create table(:bets) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :game_id, references(:games, on_delete: :delete_all)

      add :amount, :float
      add :selection, :string
      add :status, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
      add :deleted_at, :utc_datetime, default: nil

    end
  end
end
