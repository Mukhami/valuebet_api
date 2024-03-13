defmodule ValuebetApiWeb.IndexController do
  use ValuebetApiWeb, :controller

  def index(conn, _params) do
    text(conn, "ValueBetAPI!")
  end
end
