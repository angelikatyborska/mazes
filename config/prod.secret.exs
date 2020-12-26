# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
use Mix.Config

secret_key_base =
  System.get_env("MAZES_SECRET_KEY_BASE") ||
    raise """
    environment variable MAZES_SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :mazes, MazesWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "5000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

 config :mazes, MazesWeb.Endpoint, server: true
