defmodule ShortenedUrlWeb.PageController do
  use ShortenedUrlWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
