defmodule ShortenedUrl.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :original_url, :string
    field :slug, :string
    field :visits, :integer

    timestamps()
  end

  @required_fields ~w(original_url)a
  @valid_url_regex ~r/^https?:\/\/(?:www\.)?[a-zA-Z0-9-]+(?:\.[a-zA-Z]{2,})+(?:\/\S*)?$/

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:original_url, :slug, :visits])
    |> validate_required(@required_fields)
    |> validate_format(:original_url, @valid_url_regex, message: "Invalid URL")
  end
end
