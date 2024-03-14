defmodule Seeder do
  alias ValuebetApi.Repo
  alias ValuebetApi.GameManagement.Game
  alias ValuebetApi.Accounts.Role

  # Generate a random number between min and max
  defp random_number(min, max) do
    :rand.uniform(max - min + 1) + min - 1
  end

  # Seed data for games
  def seed_games do
    Enum.each(1..5, fn _ ->
      current_time = DateTime.utc_now() |> DateTime.truncate(:second)
      random_minutes = Enum.random(5..10)

      scheduled_at =
        DateTime.add(current_time, random_minutes, :minute, Calendar.UTCOnlyTimeZoneDatabase)

      home_team = "Team #{random_number(100, 999)}"
      away_team = "Team #{random_number(100, 999)}"
      home_odds = Float.round(:rand.uniform() * (3.0 - 1.0) + 1.0, 2)
      draw_odds = Float.round(:rand.uniform() * (3.0 - 1.0) + 1.0, 2)
      away_odds = Float.round(:rand.uniform() * (3.0 - 1.0) + 1.0, 2)
      result = nil
      scheduled_at = scheduled_at

      game_attrs = %{
        home_team: home_team,
        away_team: away_team,
        home_odds: home_odds,
        draw_odds: draw_odds,
        away_odds: away_odds,
        result: result,
        scheduled_at: scheduled_at
      }

      Repo.insert!(Game.changeset(%Game{}, game_attrs))
    end)
  end

  # Seed data for roles
  def seed_roles do
    roles = [
      %{name: "admin", description: "Administrator role with full access."},
      %{name: "user", description: "Standard user role with limited access."}
    ]

    Enum.each(roles, fn role_attrs ->
      case Repo.get_by(Role, name: role_attrs.name) do
        nil ->
          Repo.insert!(Role.changeset(%Role{}, role_attrs))

        _ ->
          :ok
      end
    end)
  end
end

Seeder.seed_games()
Seeder.seed_roles()
