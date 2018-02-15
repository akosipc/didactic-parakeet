defmodule BetchesWeb.BettableControllerTest do
  use BetchesWeb.ConnCase

  alias Betches.Core

  @battle_attrs %{
    title: "Some Title",
    description: "Some Description",
    accepts_at: Timex.now() |> Timex.shift(days: 3),
    starts_at: Timex.now() |> Timex.shift(days: 7),
    ends_at: Timex.now() |> Timex.shift(days: 14)
  }
  @create_attrs %{
    title: "Some Title",
    description: "Some Description",
    winning_condition: false,
    winner: false,
    sidebet: false
  }
  @update_attrs %{title: "New Title"}
  @invalid_attrs %{title: nil}

  setup %{conn: conn} do
    {:ok, battle} = Core.create_battle(@battle_attrs)

    {:ok, conn: conn, battle: battle}
  end

  def fixture(:bettable) do
    {:ok, bettable} = Core.create_bettable(@create_attrs)
    bettable
  end

  describe "index" do
    test "lists all bettables", %{conn: conn, battle: %{id: battle_id}} do
      conn = get conn, battle_bettable_path(conn, :index, battle_id)
      assert html_response(conn, 200) =~ "Listing Bettables"
    end
  end

  describe "new bettable" do
    test "renders form", %{conn: conn, battle: %{id: battle_id}} do
      conn = get conn, battle_bettable_path(conn, :new, battle_id)
      assert html_response(conn, 200) =~ "New Bettable"
    end
  end

  describe "create bettable" do
    test "redirects to show when data is valid", %{conn: conn, battle: %{id: battle_id}} do
      conn = post conn, battle_bettable_path(conn, :create, battle_id), bettable: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == battle_bettable_path(conn, :show, battle_id, id)

      conn = get conn, battle_bettable_path(conn, :show, battle_id, id)
      assert html_response(conn, 200) =~ "Show Bettable"
    end

    test "renders errors when data is invalid", %{conn: conn, battle: %{id: battle_id}} do
      conn = post conn, battle_bettable_path(conn, :create, battle_id), bettable: @invalid_attrs
      assert html_response(conn, 200) =~ "New Bettable"
    end
  end

  describe "edit bettable" do
    setup [:create_bettable]

    test "renders form for editing chosen bettable", %{conn: conn, bettable: bettable, battle: %{id: battle_id}} do
      conn = get conn, bettable_path(conn, :edit, battle_id, bettable)
      assert html_response(conn, 200) =~ "Edit Bettable"
    end
  end

  describe "update bettable" do
    setup [:create_bettable]

    test "redirects when data is valid", %{conn: conn, bettable: bettable} do
      conn = put conn, bettable_path(conn, :update, bettable), bettable: @update_attrs
      assert redirected_to(conn) == bettable_path(conn, :show, bettable)

      conn = get conn, bettable_path(conn, :show, bettable)
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, bettable: bettable} do
      conn = put conn, bettable_path(conn, :update, bettable), bettable: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Bettable"
    end
  end

  describe "delete bettable" do
    setup [:create_bettable]

    test "deletes chosen bettable", %{conn: conn, bettable: bettable} do
      conn = delete conn, bettable_path(conn, :delete, bettable)
      assert redirected_to(conn) == bettable_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, bettable_path(conn, :show, bettable)
      end
    end
  end

  defp create_bettable(_) do
    bettable = fixture(:bettable)
    {:ok, bettable: bettable}
  end
end
