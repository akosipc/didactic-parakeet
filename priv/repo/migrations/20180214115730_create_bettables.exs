defmodule Betches.Repo.Migrations.CreateBettables do
  use Ecto.Migration

  def change do
    create table(:bettables) do
      add :title, :string
      add :description, :text
      add :winning_condition, :boolean, default: false
      add :winner, :boolean, default: false
      add :sidebet, :boolean, default: false
      add :meta, :jsonb

      add :battle_id, references(:battles)

      timestamps()
    end

    create index(:bettables, :battle_id)
  end
end
