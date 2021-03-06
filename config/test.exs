import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :dnd_chat, DndChat.Repo,
  username: "postgres",
  password: "postgres",
  database: "dnd_chat_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  migration_primary_key: [name: :id, type: :binary_id]

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dnd_chat, DndChatWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
config :dnd_chat, :basic_auth, username: "user", password: "not_secret"
