defmodule FukuroLive.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      FukuroLive.Repo,
      # Start the Telemetry supervisor
      FukuroLiveWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: FukuroLive.PubSub},
      # Start the Endpoint (http/https)
      FukuroLiveWeb.Endpoint
      # Start a worker by calling: FukuroLive.Worker.start_link(arg)
      # {FukuroLive.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FukuroLive.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    FukuroLiveWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
