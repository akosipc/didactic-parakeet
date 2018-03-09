defmodule Betches.Core.Bet do
  use Ecto.Schema
  import Ecto.Changeset
  alias Betches.Core.Bet
  alias Betches.Core.Bet.Transaction
  alias Betches.Core.Bet.Crypto

  schema "bets" do
    field :amount, :float
    field :currency, :string
    field :status, :string

    embeds_one :crypto, Crypto
    embeds_one :transaction, Transaction

    belongs_to :bettable, Betches.Core.Bettable
    belongs_to :battle, Betches.Core.Battle

    timestamps()
  end

  defmodule Transaction do
    use Ecto.Schema

    embedded_schema do
      field :identifier, :string
      field :source, :string
      field :number, :string
      field :amount, :decimal
      field :date, :utc_datetime
      field :details, :map
    end

    @valid_attrs ~w(identifier source number amount date details)a

    def changeset(%Transaction{} = transaction, params \\ %{}) do
      transaction
      |> cast(params, @valid_attrs)
    end

    def update_transaction(%Transaction{} = transaction, params \\ %{}) do
      transaction
      |> cast(params, @valid_attrs)
    end
  end

  defmodule Crypto do
    use Ecto.Schema

    embedded_schema do
      field :identifier, :string
    end

    @valid_attrs ~w(identifier)

    def changeset(%Crypto{} = crypto, params \\ %{}) do
      crypto
      |> cast(params, @valid_attrs)
    end
  end

  @valid_attrs ~w(amount currency status bettable_id battle_id)a
  @required_attrs  ~w(amount currency status bettable_id battle_id)a
  @status ~w(pending paid void)
  @currency ~w(USD JPC)

  def changeset(%Bet{} = bet, attrs) do
    bet
    |> cast(attrs, @valid_attrs)
    |> validate_required(@required_attrs)
    |> validate_inclusion(:currency, @currency)
    |> validate_inclusion(:status, @status)
    |> validate_number(:amount, greater_than: 0)
    |> cast_embed(:transaction, with: &Transaction.changeset/2)
    |> cast_embed(:crypto, with: &Crypto.changeset/2)
  end
end
