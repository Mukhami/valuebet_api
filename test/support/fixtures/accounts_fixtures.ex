defmodule ValuebetApi.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ValuebetApi.Accounts` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some email#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique user msisdn.
  """
  def unique_user_msisdn, do: "some msisdn#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        deleted_at: ~U[2024-03-04 13:54:00Z],
        email: unique_user_email(),
        encrypted_password: "some encrypted_password",
        first_name: "some first_name",
        last_name: "some last_name",
        msisdn: unique_user_msisdn(),
        status: true
      })
      |> ValuebetApi.Accounts.create_user()

    user
  end

  @doc """
  Generate a role.
  """
  def role_fixture(attrs \\ %{}) do
    {:ok, role} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> ValuebetApi.Accounts.create_role()

    role
  end
end
