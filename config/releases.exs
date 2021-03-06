# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :dnd_chat, DndChat.Repo,
  ssl: true,
  url: database_url,
  migration_primary_key: [name: :id, type: :binary_id],
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :dnd_chat, DndChatWeb.Endpoint,
  server: true,
  url: [host: "dnd-chat.natelincoln.com", port: 443],
  http: [port: 80],
  https: [
    port: 443,
    cipher_suite: :strong,
    keyfile: System.get_env("SSL_KEY_FILE"),
    certfile: System.get_env("SSL_CERT_FILE")
  ],
  secret_key_base: secret_key_base,
  cache_static_manifest: "priv/static/cache_manifest.json"

config :dnd_chat, :basic_auth,
  username: System.get_env("ADMIN_USER"),
  password: System.get_env("ADMIN_PASSWORD")

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :dnd_chat, DndChatWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
