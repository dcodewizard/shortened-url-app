defmodule ShortenedUrl.LinksTest do
  use ShortenedUrl.DataCase

  alias ShortenedUrl.Links

  describe "links" do
    alias ShortenedUrl.Link

    import ShortenedUrl.ShortenedLinkFixtures

    @invalid_attrs %{original_url: nil, slug: nil, visits: nil}

    test "list_links/0 returns all links" do
      link = link_fixture()
      assert Links.list_links() == [link]
    end

    test "get_link/1 returns the link with given slug" do
      link = link_fixture()
      assert Links.get_link(link.slug) == link
    end

    test "create_link/1 with valid data creates a link" do
      valid_attrs = %{original_url: "http://bit.ly/hello", slug: "some slug", visits: 42}

      assert {:ok, %Link{} = link} = Links.create_link(valid_attrs)
      assert link.original_url == "http://bit.ly/hello"
      assert link.slug == "some slug"
      assert link.visits == 42
    end

    test "create_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Links.create_link(@invalid_attrs)
    end

    test "update_link/2 with valid data updates the link" do
      link = link_fixture()

      update_attrs = %{
        original_url: "https://bit.ly/updated",
        slug: "some updated slug",
        visits: 43
      }

      assert {:ok, %Link{} = link} = Links.update_link(link, update_attrs)
      assert link.original_url == "https://bit.ly/updated"
      assert link.slug == "some updated slug"
      assert link.visits == 43
    end

    test "update_link/2 with invalid data returns error changeset" do
      link = link_fixture()
      assert {:error, %Ecto.Changeset{}} = Links.update_link(link, @invalid_attrs)
      assert link == Links.get_link(link.slug)
    end

    test "delete_link/1 deletes the link" do
      link = link_fixture()
      assert {:ok, %Link{}} = Links.delete_link(link)
    end

    test "change_link/1 returns a link changeset" do
      link = link_fixture()
      assert %Ecto.Changeset{} = Links.change_link(link)
    end

    test "generate_custom_slug/1 generates a custom slug from the original URL" do
      original_url = "http://example.com"
      assert Links.generate_custom_slug(original_url) != nil
    end

    test "update_visits/1 increments the visit count of a link" do
      link = link_fixture()
      before_visits = link.visits
      Links.update_visits(link.slug)
      updated_link = Links.get_link(link.slug)
      assert updated_link.visits == before_visits + 1
    end

    test "link_from_url/1 returns the link for a given original URL" do
      link = link_fixture()
      assert link == Links.link_from_url(link.original_url)
    end
  end
end
