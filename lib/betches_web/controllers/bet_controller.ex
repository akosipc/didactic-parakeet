defmodule BetchesWeb.BetController do
  use BetchesWeb, :controller

  alias Betches.Core
  alias Betches.Core.Bet

  def index(conn, %{"battle_id" => battle_id}) do
    bets = Core.bets(%{battle_id: battle_id})  

    render(conn, "index.html", bets: bets)
  end

  def new(conn, %{"battle_id" => battle_Id}) do
    changeset = Core.change_bet(%Bet{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"battle_id" => battle_id, "bet" => bet_params}) do
    case Core.create_bet(Enum.into(bet_params, %{"battle_id" => battle_id})) do
      {:ok, bet} ->
        conn
        |> put_flash(:info, "Bet created successfully.")
        |> redirect(to: battle_bet_path(conn, :show, battle_id, bet))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"battle_id" => battle_id, "id" => id}) do
    bet = Core.get_bet!(id)
    render(conn, "show.html", bet: bet)
  end

  def edit(conn, %{"id" => id, "battle_id" => battle_id}) do
    bet = Core.get_bet!(battle_id, id)
    changeset = Core.change_bet(bet)
    render(conn, "edit.html", bet: bet, changeset: changeset)
  end

  def update(conn, %{"id" => id, "bet" => bet_params}) do
    bet = Core.get_bet!(id)

    case Core.update_bet(bet, bet_params) do
      {:ok, bet} ->
        conn
        |> put_flash(:info, "Bet updated successfully.")
        |> redirect(to: bet_path(conn, :show, bet))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", bet: bet, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    bet = Core.get_bet!(id)
    {:ok, _bet} = Core.delete_bet(bet)

    conn
    |> put_flash(:info, "Bet deleted successfully.")
    |> redirect(to: bet_path(conn, :index))
  end
end
