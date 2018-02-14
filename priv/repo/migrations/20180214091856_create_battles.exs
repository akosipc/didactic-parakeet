defmodule Betches.Repo.Migrations.CreateBattles do
  use Ecto.Migration

  def change do
    create table(:battles) do
      add :title, :string
      add :description, :text
      add :game, :string
      add :slug, :string
      add :meta, :jsonb

      add :starts_at, :utc_datetime
      add :ends_at, :utc_datetime
      add :accepts_at, :utc_datetime

      timestamps()
    end

    create unique_index(:battles, :slug)
  end
end
