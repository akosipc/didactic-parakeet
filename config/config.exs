# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :betches,
  ecto_repos: [Betches.Repo]

# Configures the endpoint
config :betches, BetchesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "R16BWQLXthv+GL5N/LoVYRstUaQ8Oc1aDpBeeeHHZht16/5Y6BR2MyXsmnFI6HTY",
  render_errors: [view: BetchesWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Betches.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
