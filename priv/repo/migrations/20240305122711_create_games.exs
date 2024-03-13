defmodule ValuebetApi.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :home_team, :string
      add :away_team, :string
      add :home_odds, :float
      add :draw_odds, :float
      add :away_odds, :float
      add :result, :string, default: nil
      add :scheduled_at, :utc_datetime
      timestamps(type: :utc_datetime)
      add :deleted_at, :utc_datetime, default: nil
    end
  end
end
