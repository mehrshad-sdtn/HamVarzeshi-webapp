# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :hamvarzeshi,
  ecto_repos: [Hamvarzeshi.Repo]

# Configures the endpoint
config :hamvarzeshi, HamvarzeshiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "RV/wr6PMFw6IpXXblkmorSnqHMuMxbg5FuXjmSxrKAa6jLR5lx5/qopJY20fmqAJ",
  render_errors: [view: HamvarzeshiWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Hamvarzeshi.PubSub,
  live_view: [signing_salt: "cZ7ARvGM"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# Ueberauth Config
config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, [default_scope: "email profile"]}
  ]
config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: "397588104768-emgd19clqt80l2urk6lponltfgm2rgk0.apps.googleusercontent.com", # Dummy code
  client_secret: "0za6w4vLN0hdz-02TNuAC40z", # Dummy code
  redirect_uri: "http://localhost:4000/auth/google/callback"


# This is the default config
alias DateTimeParser.Parser
config :date_time_parser, parsers: [Parser.Epoch, Parser.Serial, Parser.Tokenizer]

# To enable only specific parsers, include them in the :parsers key.
config :date_time_parser, parsers: [Parser.Tokenizer]
