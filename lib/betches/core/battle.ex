defmodule Betches.Core.Battle do
  use Ecto.Schema
  import Ecto.Changeset
  alias Betches.Core.Battle
  alias Betches.Core.Battle.Meta

  schema "battles" do
    field :title, :string
    field :description, :string
    field :game, :string
    field :slug, :string

    field :starts_at, :utc_datetime
    field :ends_at, :utc_datetime
    field :accepts_at, :utc_datetime
    embeds_one :meta, Betches.Core.Battle.Meta

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

  @valid_attrs ~w(title description starts_at accepts_at ends_at game slug)a
  @required_attrs ~w(title description starts_at accepts_at ends_at)a

  @doc false
  def changeset(%Battle{} = battle, attrs) do
    battle
    |> cast(attrs, @valid_attrs)
    |> validate_required(@required_attrs)
    |> assign_slug
    |> unique_constraint(:slug)
    |> cast_embed(:meta, with: &Meta.changeset/2)
  end

  defp assign_slug(%Ecto.Changeset{valid?: true, changes: %{title: title}} = changeset) do
    put_change(changeset, :slug, slugify(title))
  end
  defp assign_slug(changeset), do: changeset

  defp slugify(str) do
    str
    |> String.downcase()
    |> String.replace(" ", "-")
    |> String.split(" ")
    |> Enum.concat(["-#{UUID.uuid1()}"])
    |> Enum.join()
  end
end
