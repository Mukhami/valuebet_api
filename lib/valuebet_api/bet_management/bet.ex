defmodule ValuebetApi.BetManagement.Bet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bets" do
    belongs_to :user, ValuebetApi.Accounts.User
    belongs_to :game, ValuebetApi.GameManagement.Game

    field :status, :boolean, default: true
    field :won, :boolean, default: false
    field :amount, :float
    field :selection, :string
    field :winnings, :float
    field :result_status, :string
    timestamps(type: :utc_datetime)

    field :deleted_at, :utc_datetime, default: nil
  end

  @doc false
  def changeset(bet, attrs) do
    bet
    |> cast(attrs, [:user_id, :game_id, :amount, :selection, :status])
    |> validate_required([:user_id, :game_id, :amount, :selection, :status])
  end
end
