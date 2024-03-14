defmodule ValuebetApiWeb.Router do
  use ValuebetApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug ValuebetApiWeb.Auth.Pipeline
  end

  scope "/api", ValuebetApiWeb do
    pipe_through :api

    post "/users/register", UserController, :register

    post "/users/login", UserController, :login
  end

  scope "/api", ValuebetApiWeb do
    pipe_through [:api, :auth]

    get "/users/profile", UserController, :profile

    resources "/users", UserController, except: [:new, :edit]

    resources "/games", GameController, except: [:new, :edit]

    resources "/roles", RoleController, except: [:new, :edit]

    resources "/bets", BetController, except: [:new, :edit]

    get "/bets/fetch-by-user/:user_id", BetController, :user_index
  end

  pipeline :browser do
    plug(:accepts, ["html"])
  end

  scope "/", ValuebetApiWeb do
    pipe_through :browser
    get "/", IndexController, :index
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:valuebet_api, :dev_routes) do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
