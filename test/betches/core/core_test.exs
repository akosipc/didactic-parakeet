defmodule Betches.CoreTest do
  use Betches.DataCase

  alias Betches.Core

  defp adjust_time(duration), do: Timex.now() |> Timex.shift(duration)

  describe "battles" do
    alias Betches.Core.Battle

    @valid_attrs %{
      title: "Some Title",
      description: "Some Description",
      accepts_at: Timex.now() |> Timex.shift(days: 3),
      starts_at: Timex.now() |> Timex.shift(days: 7),
      ends_at: Timex.now() |> Timex.shift(days: 14)
    }
    @update_attrs %{ title: "New Title" }
    @invalid_attrs %{ title: "" }

    def battle_fixture(attrs \\ %{}) do
      {:ok, battle} =
        attrs
        |> Map.merge(@valid_attrs, fn (_key, first_value, _second_value) -> 
          first_value
        end)
        |> Core.create_battle()

      battle
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
      assert {:ok, %Battle{} = battle} = Core.create_battle(@valid_attrs)
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
