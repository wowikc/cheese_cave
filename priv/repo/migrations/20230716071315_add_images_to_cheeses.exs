defmodule CheeseCave.Repo.Migrations.AddImagesToCheeses do
  use Ecto.Migration

  def change do
    alter table(:cheeses) do
      add :photos, {:array, :string}
    end
  end
end
