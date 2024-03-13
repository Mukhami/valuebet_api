import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :valuebet_api, ValuebetApi.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "valuebet_api_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :valuebet_api, ValuebetApiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "B7TjzP2twP0qtTp/XPtGZJBO8Psk5iciSG5wsYVsZkAcxNuwQyLELiBGauO0ltTK",
  server: false

# In test we don't send emails.
config :valuebet_api, ValuebetApi.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

#Oban Test connfig
config :my_app, Oban, testing: :inline
