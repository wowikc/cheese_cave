defmodule CheeseCave.Cheeses.Cheese do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cheeses" do
    field :name, :string
    field :cheese_name, :string
    field :press_done_date, :date
    field :start_aging_date, :date

    field :photos, {:array, :string}

    timestamps()
  end

  @doc false
  def changeset(cheese, attrs) do
    cheese
    |> cast(attrs, [:name, :cheese_name, :press_done_date, :start_aging_date, :photos])
    |> validate_required([
      :name
      # :cheese_name,
      # :press_done_date,
      # :start_aging_date
    ])
  end
end
