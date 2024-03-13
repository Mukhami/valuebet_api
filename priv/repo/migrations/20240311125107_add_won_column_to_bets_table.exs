defmodule ValuebetApi.Repo.Migrations.AddWonColumnToBetsTable do
  use Ecto.Migration

  def change do
    alter table(:bets) do
      add :won, :boolean, default: false, null: false
    end
  end
end
