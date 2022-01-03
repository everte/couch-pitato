# This file is responsible for configuring your application
# use Mix.config
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
import Config

# Enable the Nerves integration with Mix
Application.start(:nerves_bootstrap)

# import_config "../../ui/config/config.exs"
# import_config "../../ui/config/prod.exs"
config :firmware, target: Mix.target()

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

config :nerves, :firmware, fwup_conf: "config/fwup.conf"

# Set the SOURCE_DATE_EPOCH date for reproducible builds.
# See https://reproducible-builds.org/docs/source-date-epoch/ for more information

config :nerves, source_date_epoch: "1608666057"

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.

config :logger, backends: [RingLogger]

if Mix.target() != :host do
  import_config "target.exs"
  import_config "#{config_env()}.exs"
end

# https://hexdocs.pm/nerves/user-interfaces.html

# When we deploy to a device, we use the "prod" configuration:
# import_config "../../ui/config/config.exs"
# import_config "../../ui/config/prod.exs"

# config :ui, UiWeb.Endpoint,
# Nerves root filesystem is read-only, so disable the code reloader
# code_reloader: false,
# http: [port: 80],
# Use compile-time Mix config instead of runtime environment variables
# load_from_system_env: false,
# Start the server since we're running in a release instead of through `mix`
# server: true,
# url: [host: "nerves.local", port: 80]
