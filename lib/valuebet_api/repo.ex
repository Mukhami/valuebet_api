defmodule ValuebetApi.Repo do
  use Ecto.Repo,
    otp_app: :valuebet_api,
    adapter: Ecto.Adapters.Postgres
end
