defmodule ShortenedUrl.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ShortenedUrl.Repo,
      # Start the Telemetry supervisor
      ShortenedUrlWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ShortenedUrl.PubSub},
      # Start the Endpoint (http/https)
      ShortenedUrlWeb.Endpoint,
      # Start a worker by calling: ShortenedUrl.Worker.start_link(arg)
      # {ShortenedUrl.Worker, arg}
      {Cachex, :my_cache}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ShortenedUrl.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ShortenedUrlWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
