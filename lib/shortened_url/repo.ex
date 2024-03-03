defmodule ShortenedUrl.Repo do
  use Ecto.Repo,
    otp_app: :shortened_url,
    adapter: Ecto.Adapters.Postgres
end
