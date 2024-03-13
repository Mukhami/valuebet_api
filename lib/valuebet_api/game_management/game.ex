defmodule ValuebetApi.GameManagement.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :result, :string, default: nil
    field :home_team, :string
    field :away_team, :string
    field :home_odds, :float
    field :draw_odds, :float
    field :away_odds, :float
    field :scheduled_at, :utc_datetime
    timestamps(type: :utc_datetime)
    field :deleted_at, :utc_datetime, default: nil
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [
      :home_team,
      :away_team,
      :home_odds,
      :draw_odds,
      :away_odds,
      :scheduled_at
    ])
    |> validate_required([
      :home_team,
      :away_team,
      :home_odds,
      :draw_odds,
      :away_odds,
      :scheduled_at
    ])
  end
end
