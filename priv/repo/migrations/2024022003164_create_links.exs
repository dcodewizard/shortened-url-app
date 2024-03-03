defmodule ShortenedUrl.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :original_url, :string
      add :slug, :string
      add :visits, :integer, default: 0

      timestamps()
    end
  end
end
