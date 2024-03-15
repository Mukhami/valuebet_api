defmodule ValuebetApi.GameManagement.Jobs.SendEmailJob do
  use Oban.Worker, queue: :mailer, max_attempts: 1, priority: 2

  alias ValuebetApi.Mailer

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"email" => email_args}}) do
    with email <- Mailer.from_map(email_args),
         {:ok, _metadata} <- Mailer.deliver(email) do
      :ok
    end
  end
end
