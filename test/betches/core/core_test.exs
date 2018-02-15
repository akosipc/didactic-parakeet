defmodule Betches.CoreTest do
  use Betches.DataCase

  alias Betches.Core

  defp adjust_time(duration), do: Timex.now() |> Timex.shift(duration)

  describe "battles and bettables" do
    alias Betches.Core.Battle
    alias Betches.Core.Bettable

    @valid_attrs_for_battles %{
      title: "Some Title",
      description: "Some Description",
      accepts_at: Timex.now() |> Timex.shift(days: 3),
      starts_at: Timex.now() |> Timex.shift(days: 7),
      ends_at: Timex.now() |> Timex.shift(days: 14)
    }
    @valid_attrs_for_bettables %{
      title: "Some Title",
      description: "Some Description",
      winning_condition: false,
      winner: false,
      sidebet: false
    }
    @update_attrs %{ title: "New Title" }
    @invalid_attrs %{ title: "" }

    def battle_fixture(attrs \\ %{}) do
      {:ok, battle} =
        attrs
        |> Map.merge(@valid_attrs_for_battles, fn (_key, first_value, _) -> first_value end)
        |> Core.create_battle()

      battle
    end

    def bettable_fixture(attrs \\ %{}) do
      {:ok, bettable} = 
        attrs
        |> Map.merge(@valid_attrs_for_bettables, fn (_key, first_value, _) -> first_value end)
        |> Core.create_bettable()

      bettable
    end

    test "bettables/1 returns all bettables" do
      battle = battle_fixture()
      bettable = bettable_fixture(%{battle_id: battle.id})

      assert Core.bettables(battle.id) == [bettable]
    end

    test "bettables/2 paseed `:sidebets` returns all bettables that are sidebets" do
      battle = battle_fixture()
      bettable = bettable_fixture(%{battle_id: battle.id, sidebet: true})

      assert Core.bettables(battle.id, :sidebets) == [bettable]
    end

    test "bettables/2 paseed `:winning_conditions` returns all bettables that are sidebets" do
      battle = battle_fixture()
      bettable = bettable_fixture(%{battle_id: battle.id, winning_condition: true})

      assert Core.bettables(battle.id, :winning_conditions) == [bettable]
    end

    test "get_bettable!/2 returns the bettable with given id" do
      battle = battle_fixture()
      bettable = bettable_fixture(%{battle_id: battle.id})

      assert Core.get_bettable!(battle.id, bettable.id) == bettable
    end

    test "create_bettable/1 with valid data creates a bettable" do
      battle = battle_fixture()
      assert {:ok, %Bettable{} = bettable} = Core.create_bettable(Enum.into(@valid_attrs_for_bettables, %{battle_id: battle.id}))
      assert bettable.title == "Some Title"
    end

    test "create_bettable/1 with invalid data returns error changeset" do
      battle = battle_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.create_bettable(Enum.into(@invalid_attrs, %{battle_id: battle.id}))
    end

    test "update_bettable/2 with valid data updates the bettable" do
      battle = battle_fixture()
      bettable = bettable_fixture(%{battle_id: battle.id})
      assert {:ok, bettable} = Core.update_bettable(bettable, @update_attrs)
      assert %Bettable{} = bettable
      assert bettable.title == "New Title"
    end

    test "update_bettable/2 with invalid data returns error changeset" do
      battle = battle_fixture()
      bettable = bettable_fixture(%{battle_id: battle.id})
      assert {:error, %Ecto.Changeset{}} = Core.update_bettable(bettable, @invalid_attrs)
      assert bettable == Core.get_bettable!(battle.id, bettable.id)
    end

    test "delete_bettable/1 deletes the bettable" do
      battle = battle_fixture()
      bettable = bettable_fixture(%{battle_id: battle.id})

      assert {:ok, %Bettable{}} = Core.delete_bettable(bettable)
    end

    test "change_bettable/1 returns a bettable changeset" do
      battle = battle_fixture()
      bettable = bettable_fixture(%{battle_id: battle.id})
      assert %Ecto.Changeset{} = Core.change_bettable(bettable)
    end

    test "battles/0 returns all battles" do
      battle = battle_fixture()

      assert Core.battles() == [battle]
    end

    test "battles/1 passed `:ready` returns all battles that are ready do betting" do
      battle = battle_fixture()

      assert Core.battles(:ready) == [battle]
    end

    test "battles/1 passed `:not_accepting` returns all battles that are not accepting bets" do
      battle = battle_fixture(%{accepts_at: adjust_time(days: -3)})

      assert Core.battles(:not_accepting) == [battle]
    end

    test "battles/1 passed :live returns all battles that are currently live" do
      battle = battle_fixture(%{accepts_at: adjust_time(days: -10), starts_at: adjust_time(days: -7)})

      assert Core.battles(:live) == [battle]
    end

    test "battles/1 passed :ended returns all battles that are finished" do
      battle = battle_fixture(%{accepts_at: adjust_time(days: -21), starts_at: adjust_time(days: -18), ends_at: adjust_time(days: -14)})

      assert Core.battles(:ended) == [battle]
    end

    test "get_battle/1 when ID was passed" do
      battle = battle_fixture() 

      assert Core.get_battle!(battle.id) == battle
    end

    test "get_battle/1 when slug map was passed" do
      battle = battle_fixture() 

      assert Core.get_battle!(%{slug: battle.slug}) == battle
    end

    test "create_battle/1 with valid data creates a battle" do
      assert {:ok, %Battle{} = battle} = Core.create_battle(@valid_attrs_for_battles)
      assert battle.title == "Some Title"
    end

    test "create_battle/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_battle(@invalid_attrs)
    end

    test "update_battle/2 with valid data updates the battle" do
      battle = battle_fixture()
      assert {:ok, battle} = Core.update_battle(battle, @update_attrs)
      assert %Battle{} = battle
      assert battle.title == "New Title"
    end

    test "update_battle/2 with invalid data returns error changeset" do
      battle = battle_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_battle(battle, @invalid_attrs)
      assert battle == Core.get_battle!(battle.id)
    end

    test "delete_battle/1 deletes the battle" do
      battle = battle_fixture()
      assert {:ok, %Battle{}} = Core.delete_battle(battle)
      assert_raise Ecto.NoResultsError, fn -> Core.get_battle!(battle.id) end
    end

    test "change_battle/1 returns a battle changeset" do
      battle = battle_fixture()
      assert %Ecto.Changeset{} = Core.change_battle(battle)
    end
  end
end
