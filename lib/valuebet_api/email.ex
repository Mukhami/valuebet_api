defmodule ValuebetApi.Email do

  import Swoosh.Email

  def create_email(recipient, subject, body) do
    new()
      |> to(recipient)
      |> from("notifications@valuebet.com")
      |> subject(subject)
      |> text_body(body)
  end
end
