defmodule Clothingstore.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ClothingstoreWeb.Telemetry,
      Clothingstore.Repo,
      {DNSCluster, query: Application.get_env(:clothingstore, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Clothingstore.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Clothingstore.Finch},
      # Start a worker by calling: Clothingstore.Worker.start_link(arg)
      # {Clothingstore.Worker, arg},
      # Start to serve requests, typically the last entry
      ClothingstoreWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Clothingstore.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ClothingstoreWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
