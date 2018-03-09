defmodule Betches.Core.Bettable do
  use Ecto.Schema
  import Ecto.Changeset
  alias Betches.Core.Bettable
  alias Betches.Core.Bettable.Meta

  schema "bettables" do
    field :title, :string
    field :description, :string

    field :winning_condition, :boolean
    field :winner, :boolean
    field :sidebet, :boolean

    embeds_one :meta, Meta

    belongs_to :battle, Betches.Core.Battle
    has_many :bets, Betches.Core.Bet

    timestamps()
  end

  defmodule Meta do
    use Ecto.Schema

    embedded_schema do
      field :title, :string
      field :image, :string
      field :description, :string
    end

    @valid_attrs ~w(title image description)a
    @required_attrs ~w(title description)a

    def changeset(%Meta{} = meta, attrs \\ %{}) do
      meta
      |> cast(attrs, @valid_attrs)
      |> validate_required(@required_attrs)
    end
  end

  @valid_attrs ~w(title description winning_condition winner sidebet battle_id)a
  @required_attrs ~w(title description winning_condition battle_id)a

  @doc false
  def changeset(%Bettable{} = bettable, attrs) do
    bettable
    |> cast(attrs, @valid_attrs)
    |> validate_required(@required_attrs)
    |> cast_embed(:meta, with: &Meta.changeset/2)
  end
end
