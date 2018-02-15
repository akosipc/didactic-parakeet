defmodule BetchesWeb.BettableController do
  use BetchesWeb, :controller

  alias Betches.Core
  alias Betches.Core.Bettable

  def index(conn, %{"battle_id" => battle_id}) do
    bettables = Core.bettables(battle_id)
    render(conn, "index.html", bettables: bettables)
  end

  def new(conn, %{"battle_id" => battle_id}) do
    changeset = Core.change_bettable(%Bettable{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"battle_id" => battle_id, "bettable" => bettable_params}) do
    case Core.create_bettable(Enum.into(bettable_params, %{"battle_id" => battle_id})) do
      {:ok, bettable} ->
        conn
        |> put_flash(:info, "Bettable created successfully.")
        |> redirect(to: battle_bettable_path(conn, :show, battle_id, bettable))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"battle_id" => battle_id, "id" => id}) do
    bettable = Core.get_bettable!(battle_id, id)
    render(conn, "show.html", bettable: bettable)
  end

  def edit(conn, %{"id" => id}) do
    bettable = Core.get_bettable!(id)
    changeset = Core.change_bettable(bettable)
    render(conn, "edit.html", bettable: bettable, changeset: changeset)
  end

  def update(conn, %{"id" => id, "bettable" => bettable_params}) do
    bettable = Core.get_bettable!(id)

    case Core.update_bettable(bettable, bettable_params) do
      {:ok, bettable} ->
        conn
        |> put_flash(:info, "Bettable updated successfully.")
        |> redirect(to: bettable_path(conn, :show, bettable))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", bettable: bettable, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    bettable = Core.get_bettable!(id)
    {:ok, _bettable} = Core.delete_bettable(bettable)

    conn
    |> put_flash(:info, "Bettable deleted successfully.")
    |> redirect(to: bettable_path(conn, :index))
  end
end
