defmodule ShortenedUrl.RateLimit do
  import Plug.Conn
  alias RateLimiter

  def init(_opts), do: nil

  def call(conn, _opts) do
    path = conn.request_path

    case path do
      "/urls" ->
        check_rate_limit(5000, 5, conn)

      _ ->
        check_rate_limit(1000, 25, conn)
    end
  end

  defp check_rate_limit(scale, limit, conn) do
    limiter = RateLimiter.new(scale, limit)

    case RateLimiter.hit(limiter) do
      :ok ->
        conn

      :error ->
        handle_rate_limit_exceeded(conn)
    end
  end

  def handle_rate_limit_exceeded(conn) do
    conn
    |> put_status(:too_many_requests)
    |> put_resp_content_type("application/json")
    |> halt()
  end
end
