defmodule ValuebetApiWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :valuebet_api,
    module: ValuebetApiWeb.Auth.Guardian,
    error_handler: ValuebetApiWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
