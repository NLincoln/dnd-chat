# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :dnd_chat,
  ecto_repos: [DndChat.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :dnd_chat, DndChatWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Gf5QT9Ia0MP3m2PIEvCbew7Gbxul3fDg3nWIDx6Xe0GQW6KMCoZTZNTThOUxfDkF",
  render_errors: [view: DndChatWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: DndChat.PubSub,
  live_view: [signing_salt: "wMxOYiEn"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
