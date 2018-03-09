defmodule Betches.Repo.Migrations.CreateBets do
  use Ecto.Migration

  def change do
    create table(:bets) do
      add :amount, :float
      add :currency, :string
      add :status, :string, default: "pending"
      add :transaction, :jsonb
      add :crypto, :jsonb

      add :battle_id, references(:battles)
      add :bettable_id, references(:bettables)

      timestamps()
    end

    create index(:bets, [:battle_id, :bettable_id])
  end
end
