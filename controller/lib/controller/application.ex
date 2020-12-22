defmodule Controller.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Controller.Worker.start_link(arg)
      # {Controller.Worker, arg}
      {Phoenix.PubSub, name: Controller.PubSub},
      {Controller, name: :subscription}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Controller.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
