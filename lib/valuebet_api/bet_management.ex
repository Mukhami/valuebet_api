defmodule ValuebetApi.BetManagement do
  @moduledoc """
  The BetManagement context.
  """

  import Ecto.Query, warn: false
  alias ValuebetApi.Repo

  alias ValuebetApi.BetManagement.Bet

  @doc """
  Returns the list of bets.

  ## Examples

      iex> list_bets()
      [%Bet{}, ...]

  """
  def list_bets do
    query = from(b in Bet, order_by: [desc: b.id])
    Repo.all(query) |> Repo.preload([:user, :game])
  end

  @doc """
  Returns the list of bets under a user.

  ## Examples

      iex> list_bets_for_user()
      [%Bet{}, ...]

  """
  def list_bets_for_user(user_id) do
    query =
      from b in Bet,
        where: b.user_id == ^user_id,
        order_by: [desc: b.id]

    Repo.all(query) |> Repo.preload([:user, :game])
  end

  @doc """
  Gets a single bet.

  Raises `Ecto.NoResultsError` if the Bet does not exist.

  ## Examples

      iex> get_bet!(123)
      %Bet{}

      iex> get_bet!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bet!(id), do: Repo.get!(Bet, id) |> Repo.preload([:user, :game])

  @doc """
  Creates a bet.

  ## Examples

      iex> create_bet(%{field: value})
      {:ok, %Bet{}}

      iex> create_bet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bet(attrs \\ %{}) do
    %Bet{}
    |> Bet.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bet.

  ## Examples

      iex> update_bet(bet, %{field: new_value})
      {:ok, %Bet{}}

      iex> update_bet(bet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bet(%Bet{} = bet, attrs) do
    bet
    |> Bet.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a bet.

  ## Examples

      iex> delete_bet(bet)
      {:ok, %Bet{}}

      iex> delete_bet(bet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bet(%Bet{} = bet) do
    Repo.delete(bet)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bet changes.

  ## Examples

      iex> change_bet(bet)
      %Ecto.Changeset{data: %Bet{}}

  """
  def change_bet(%Bet{} = bet, attrs \\ %{}) do
    Bet.changeset(bet, attrs)
  end

  @doc """
  Caclulates the bet snapshot.
  This is used to calculate the total number of bets, won bets, lost bets, cancelled bets etc.
  """
  def  fetch_bet_snapshpot() do
    total_bets = Repo.aggregate(Bet, :count, :id)

    won_bets_query = from(b in Bet, where: b.result_status == "won")
    won_bets = Repo.aggregate(won_bets_query, :count, :id)

    lost_bets_query = from(b in Bet, where: b.result_status == "lost")
    lost_bets = Repo.aggregate(lost_bets_query, :count, :id)

    cancelled_bets_query = from(b in Bet, where: b.status == false)
    cancelled_bets = Repo.aggregate(cancelled_bets_query, :count, :id)

    total_amount_placed_query = from(b in Bet, select: sum(b.amount))
    total_amount_placed = Repo.one(total_amount_placed_query)

    winnings_query = from(b in Bet, where: b.result_status == "won", select: sum(b.winnings))
    winnings = Repo.one(winnings_query)

    %{total_bets: total_bets, won_bets: won_bets, lost_bets: lost_bets, cancelled_bets: cancelled_bets, total_amount_placed: total_amount_placed,total_winnings: winnings}
  end
end
