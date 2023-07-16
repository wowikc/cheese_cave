defmodule CheeseCave.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      CheeseCaveWeb.Telemetry,
      # Start the Ecto repository
      CheeseCave.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: CheeseCave.PubSub},
      # Start Finch
      {Finch, name: CheeseCave.Finch},
      # Start the Endpoint (http/https)
      CheeseCaveWeb.Endpoint
      # Start a worker by calling: CheeseCave.Worker.start_link(arg)
      # {CheeseCave.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CheeseCave.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CheeseCaveWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
