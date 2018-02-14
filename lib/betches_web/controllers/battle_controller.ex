defmodule BetchesWeb.BattleController do
  use BetchesWeb, :controller

  alias Betches.Core
  alias Betches.Core.Battle

  def index(conn, _params) do
    battles = Core.battles()
    render(conn, "index.html", battles: battles)
  end

  def new(conn, _params) do
    changeset = Core.change_battle(%Battle{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"battle" => battle_params}) do
    case Core.create_battle(battle_params) do
      {:ok, battle} ->
        conn
        |> put_flash(:info, "Battle created successfully.")
        |> redirect(to: battle_path(conn, :show, battle))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    battle = Core.get_battle!(id)
    render(conn, "show.html", battle: battle)
  end

  def edit(conn, %{"id" => id}) do
    battle = Core.get_battle!(id)
    changeset = Core.change_battle(battle)
    render(conn, "edit.html", battle: battle, changeset: changeset)
  end

  def update(conn, %{"id" => id, "battle" => battle_params}) do
    battle = Core.get_battle!(id)

    case Core.update_battle(battle, battle_params) do
      {:ok, battle} ->
        conn
        |> put_flash(:info, "Battle updated successfully.")
        |> redirect(to: battle_path(conn, :show, battle))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", battle: battle, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    battle = Core.get_battle!(id)
    {:ok, _battle} = Core.delete_battle(battle)

    conn
    |> put_flash(:info, "Battle deleted successfully.")
    |> redirect(to: battle_path(conn, :index))
  end
end
