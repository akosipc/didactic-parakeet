defmodule Betches.Core do
  use Timex 

  import Ecto.Query, warn: false

  alias Betches.Repo
  alias Betches.Core.Battle

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
end
