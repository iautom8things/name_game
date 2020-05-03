# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :name_game, NameGameWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "01bNuxwMIQHTnJjaLOFA2HYdOta5+5bElOO+eJhcA6bP8i6SyLucVRoRxzoa0dsX",
  render_errors: [view: NameGameWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: NameGame.PubSub,
  live_view: [signing_salt: "6jh33It/"]

config :name_game, MyAppWeb.Endpoint,
  live_view: [
    signing_salt: "SECRET_SALT"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
