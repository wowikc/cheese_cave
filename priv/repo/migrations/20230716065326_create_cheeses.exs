defmodule CheeseCave.Repo.Migrations.CreateCheeses do
  use Ecto.Migration

  def change do
    create table(:cheeses) do
      add :name, :string
      add :cheese_name, :string
      add :press_done_date, :date
      add :start_aging_date, :date

      timestamps()
    end
  end
end
