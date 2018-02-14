defmodule BetchesWeb.BattleControllerTest do
  use BetchesWeb.ConnCase

  alias Betches.Core

  @create_attrs %{
    title: "Some Title",
    description: "Some Description",
    accepts_at: Timex.now() |> Timex.shift(days: 3),
    starts_at: Timex.now() |> Timex.shift(days: 7),
    ends_at: Timex.now() |> Timex.shift(days: 14)
  }
  @update_attrs %{ title: "New Title" }
  @invalid_attrs %{ title: "" }

  def fixture(:battle) do
    {:ok, battle} = Core.create_battle(@create_attrs)
    battle
  end

  describe "index" do
    test "lists all battles", %{conn: conn} do
      conn = get conn, battle_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Battles"
    end
  end

  describe "new battle" do
    test "renders form", %{conn: conn} do
      conn = get conn, battle_path(conn, :new)
      assert html_response(conn, 200) =~ "New Battle"
    end
  end

  describe "create battle" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, battle_path(conn, :create), battle: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == battle_path(conn, :show, id)

      conn = get conn, battle_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Battle"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, battle_path(conn, :create), battle: @invalid_attrs
      assert html_response(conn, 200) =~ "New Battle"
    end
  end

  describe "edit battle" do
    setup [:create_battle]

    test "renders form for editing chosen battle", %{conn: conn, battle: battle} do
      conn = get conn, battle_path(conn, :edit, battle)
      assert html_response(conn, 200) =~ "Edit Battle"
    end
  end

  describe "update battle" do
    setup [:create_battle]

    test "redirects when data is valid", %{conn: conn, battle: battle} do
      conn = put conn, battle_path(conn, :update, battle), battle: @update_attrs
      assert redirected_to(conn) == battle_path(conn, :show, battle)

      conn = get conn, battle_path(conn, :show, battle)
      assert html_response(conn, 200) =~ "New Title"
    end

    test "renders errors when data is invalid", %{conn: conn, battle: battle} do
      conn = put conn, battle_path(conn, :update, battle), battle: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Battle"
    end
  end

  describe "delete battle" do
    setup [:create_battle]

    test "deletes chosen battle", %{conn: conn, battle: battle} do
      conn = delete conn, battle_path(conn, :delete, battle)
      assert redirected_to(conn) == battle_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, battle_path(conn, :show, battle)
      end
    end
  end

  defp create_battle(_) do
    battle = fixture(:battle)
    {:ok, battle: battle}
  end
end
