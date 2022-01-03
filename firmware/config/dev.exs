# dev/staging test config

import Config

config :mdns_lite,
  # The `host` key specifies what hostnames mdns_lite advertises.  `:hostname`
  # advertises the device's hostname.local. For the official Nerves systems, this
  # is "nerves-<4 digit serial#>.local".  mdns_lite also advertises
  # "nerves.local" for convenience. If more than one Nerves device is on the
  # network, delete "nerves" from the list.

  host: [:hostname, "nerves-dev"],
  ttl: 120,

  # Advertise the following services over mDNS.
  services: [
    %{
      name: "SSH Remote Login Protocol",
      protocol: "ssh",
      transport: "tcp",
      port: 22
    },
    %{
      name: "Secure File Transfer Protocol over SSH",
      protocol: "sftp-ssh",
      transport: "tcp",
      port: 22
    },
    %{
      name: "Erlang Port Mapper Daemon",
      protocol: "epmd",
      transport: "tcp",
      port: 4369
    }
  ]

config :ui, UiWeb.Endpoint,
  url: [host: "nerves-dev.local"],
  http: [port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: "HEY05EB1dFVSu6KykKHuS4rQPQzSHv4F7mGVB/gnDLrIu75wE/ytBXy2TaL3A6RA",
  live_view: [signing_salt: "AAAABjEyERMkxgDh"],
  check_origin: false,
  render_errors: [view: UiWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Ui.PubSub,
  # Start the server since we're running in a release instead of through `mix`
  server: true,
  # Nerves root filesystem is read-only, so disable the code reloader
  code_reloader: false,
  watchers: [],
  live_reload: []

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ui, Ui.Repo,
  database: "/data/db.db",
  journal_mode: :off
