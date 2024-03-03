defmodule ShortenedUrl.LinkTest do
  use ShortenedUrl.DataCase

  alias ShortenedUrl.Link

  describe "changeset/2" do
    test "valid changeset" do
      changeset =
        Link.changeset(%Link{}, %{original_url: "http://example.com", slug: "example", visits: 10})

      assert changeset.valid?
    end

    test "invalid changeset with missing original_url" do
      changeset = Link.changeset(%Link{}, %{slug: "example", visits: 10})
      assert changeset.valid? == false
      assert [original_url: {"can't be blank", [validation: :required]}] = changeset.errors
    end

    test "invalid changeset with invalid URL format" do
      changeset =
        Link.changeset(%Link{}, %{original_url: "invalid-url", slug: "example", visits: 10})

      assert changeset.valid? == false
      assert [original_url: {"Invalid URL", [validation: :format]}] = changeset.errors
    end
  end
end
