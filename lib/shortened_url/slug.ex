defmodule ShortenedUrl.Slug do
  @moduledoc """
  Slug Generation
  """

  @doc """
  Generate slug by creating v5 UUID, passing it through `phash2` to create
  an integer and converts that to a hex string.
  """
  def generate(url) do
    case url do
      nil ->
        nil

      url ->
        UUID.uuid5(:url, url, :hex)
        |> :erlang.phash2()
        |> Integer.to_string(16)
    end
  end

  def slug_to_url(slug) do
    "http://localhost:4000/#{slug}"
  end
end
