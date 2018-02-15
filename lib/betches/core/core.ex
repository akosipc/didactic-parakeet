defmodule Betches.Core do
  use Timex 
  import Ecto.Query, warn: false

  alias Betches.Repo
  alias Betches.Core.Battle
  alias Betches.Core.Bettable
  
  @doc """ 
  Battle API
  """

  def battles(:ready) do
    Repo.all(from b in Battle, where: b.accepts_at > ^Timex.now())
  end
  def battles(:not_accepting) do
    Repo.all(from b in Battle, where: b.accepts_at < ^Timex.now())
  end
  def battles(:live) do
    Repo.all(from b in Battle, where: b.ends_at > ^Timex.now() and b.starts_at < ^Timex.now())
  end
  def battles(:ended) do
    Repo.all(from b in Battle, where: b.ends_at < ^Timex.now())
  end
  def battles(), do: Repo.all(Battle)

  def get_battle!(%{slug: slug}), do: Repo.one!(from b in Battle, where: b.slug == ^slug)
  def get_battle!(id), do: Repo.get!(Battle, id)

  def create_battle(attrs \\ %{}) do
    %Battle{}
    |> Battle.changeset(attrs)
    |> Repo.insert()
  end

  def update_battle(%Battle{} = battle, attrs) do
    battle
    |> Battle.changeset(attrs)
    |> Repo.update()
  end

  def delete_battle(%Battle{} = battle), do: Repo.delete(battle)
  def change_battle(%Battle{} = battle), do: Battle.changeset(battle, %{})

  @doc """
  Bettable API
  """
  def bettables(battle_id, :sidebets) do
    Repo.all(from b in Bettable, where: b.battle_id == ^battle_id and b.sidebet == true)
  end
  def bettables(battle_id, :winning_conditions) do
    Repo.all(from b in Bettable, where: b.battle_id == ^battle_id and b.winning_condition == true)
  end
  def bettables(battle_id), do: Repo.all(from b in Bettable, where: b.battle_id == ^battle_id)

  def get_bettable!(battle_id, id) do 
    Repo.one(from b in Bettable, where: b.battle_id == ^battle_id and b.id == ^id)
  end

  def create_bettable(attrs \\ %{}) do
    %Bettable{}
    |> Bettable.changeset(attrs)
    |> Repo.insert()
  end

  def update_bettable(%Bettable{} = bettable, attrs) do
    bettable
    |> Bettable.changeset(attrs)
    |> Repo.update()
  end

  def delete_bettable(%Bettable{} = bettable) do
    Repo.delete(bettable)
  end

  def change_bettable(%Bettable{} = bettable) do
    Bettable.changeset(bettable, %{})
  end
end
