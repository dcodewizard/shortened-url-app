defmodule ShortenedUrl.Links do
  @moduledoc """
  The ShortenedLink context.
  """

  import Ecto.Query, warn: false
  alias ShortenedUrl.Repo

  alias ShortenedUrl.Link

  @doc """
  Returns the list of links.

  ## Examples

      iex> list_links()
      [%Link{}, ...]

  """
  def list_links do
    Repo.all(Link)
  end

  def generate_custom_slug(original_url) do
    # Generate a unique identifier from the original URL using a hashing algorithm
    # In this example, we'll use SHA-256 hashing algorithm
    hash = :crypto.hash(:sha256, original_url)
    # Convert the hash to a hexadecimal string
    slug = Base.encode16(hash, case: :lower)
    # Trim the string to get the desired length
    String.slice(slug, 0, 8)
  end

  def update_visits(slug) do
    # Retrieve the link from the database
    link = get_link(slug)

    # Update the visit count
    new_visits = link.visits + 1

    # Update the link with the new visit count
    link
    |> update_link(%{visits: new_visits})
  end

  @doc """
  Gets a single link.

  Raises `Ecto.NoResultsError` if the Link does not exist.

  ## Examples

      iex> get_link(123)
      %Link{}

      iex> get_link(456)
      ** (Ecto.NoResultsError)

  """

  def get_link(slug), do: Repo.get_by(Link, slug: slug)

  def link_from_url(url) do
    Repo.one(from l in Link, where: l.original_url == ^url)
  end

  @doc """
  Creates a link.

  ## Examples

      iex> create_link(%{field: value})
      {:ok, %Link{}}

      iex> create_link(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_link(attrs \\ %{}) do
    %Link{}
    |> Link.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a link.

  ## Examples

      iex> update_link(link, %{field: new_value})
      {:ok, %Link{}}

      iex> update_link(link, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_link(%Link{} = link, attrs) do
    link
    |> Link.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a link.

  ## Examples

      iex> delete_link(link)
      {:ok, %Link{}}

      iex> delete_link(link)
      {:error, %Ecto.Changeset{}}

  """
  def delete_link(%Link{} = link) do
    Repo.delete(link)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking link changes.

  ## Examples

      iex> change_link(link)
      %Ecto.Changeset{data: %Link{}}

  """
  def change_link(%Link{} = link, attrs \\ %{}) do
    Link.changeset(link, attrs)
  end
end
