import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :shortened_url, ShortenedUrl.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "shortened_url_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :shortened_url, ShortenedUrlWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "zr9JdxwJNI979JI8g4mv1P8ppvz0H/fLZBhfjzow7fGTWqV++vDDk1mm27HY4oBW",
  server: false

# In test we don't send emails.
config :shortened_url, ShortenedUrl.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
