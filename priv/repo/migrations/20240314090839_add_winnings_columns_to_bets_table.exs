defmodule ValuebetApi.Repo.Migrations.AddWinningsColumnsToBetsTable do
  use Ecto.Migration

  def change do
    alter table(:bets) do
      add :winnings, :float, null: true
      add :result_status, :string, null: true
    end
  end
end
