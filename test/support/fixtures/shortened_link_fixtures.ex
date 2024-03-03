defmodule ShortenedUrl.ShortenedLinkFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ShortenedUrl.Link` context.
  """

  @doc """
  Generate shorten link.
  """
  def link_fixture(attrs \\ %{}) do
    {:ok, link} =
      attrs
      |> Enum.into(%{
        original_url: "http://bit.ly/hello",
        slug: "some slug",
        visits: 42
      })
      |> ShortenedUrl.Links.create_link()

    link
  end
end
