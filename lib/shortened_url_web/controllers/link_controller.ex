defmodule ShortenedUrlWeb.LinkController do
  use ShortenedUrlWeb, :controller
  alias ShortenedUrl.{Links, Link, Slug}

  def new(conn, _params) do
    changeset = Links.change_link(%Link{})
    render(conn, "new.html", changeset: changeset)
  end

  @doc """
  Display the original URL and Shortened URL and redirect to it - update vsits
  """
  def show(conn, %{"slug" => slug}) do
    case ShortenedUrl.Cache.get(slug) do
      {:ok, nil} ->
        conn
        |> redirect(to: Routes.link_path(conn, :new))

      {:ok, original_url} ->
        Links.update_visits(slug)

        conn
        |> redirect(external: original_url)
    end
  end

  def shorten_url(conn, %{"link" => link_params}) do
    url = link_params["original_url"]
    slug = Slug.generate(url)

    case ShortenedUrl.Cache.get(slug) do
      {:ok, nil} ->
        # Original URL not found in cache, try to create a shortened URL
        save_and_cache_the_url(conn, link_params, slug)

      {:ok, original_url} ->
        # Original URL found in cache, redirect to the shortened URL directly

        conn
        |> render("show.html",
          shortened_url: Routes.link_url(conn, :show, slug),
          original_url: original_url
        )
    end
  end

  defp save_and_cache_the_url(conn, link_params, slug) do
    case Links.create_link(Map.put(link_params, "slug", slug)) do
      {:ok, link} ->
        ShortenedUrl.Cache.put(link.slug, link.original_url)

        conn
        |> put_flash(:info, "URL shortened successfully.")
        |> render("show.html",
          shortened_url: Routes.link_url(conn, :show, link.slug),
          original_url: link.original_url
        )

      {:error, changeset} ->
        render(conn, "new.html",
          changeset: changeset,
          action: Routes.link_path(conn, :shorten_url)
        )
    end
  end

  def stats(conn, _params) do
    # Query the database to retrieve shortened URL data
    links_stats = Links.list_links()

    render(conn, "stats.html", stats: links_stats)
  end

  def download_csv(conn, _params) do
    links = ShortenedUrl.Links.list_links()

    csv_header = "Shortened URL,Original URL,Visits\n"
    csv_rows = Enum.map(links, &format_csv_row(&1))
    csv_data = csv_header <> Enum.join(csv_rows, "\n")

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=shortened_urls.csv")
    |> send_resp(200, csv_data)
  end

  defp format_csv_row(%Link{slug: slug, original_url: original_url, visits: visits}) do
    "#{Slug.slug_to_url(slug)},#{original_url},#{visits}"
  end
end
