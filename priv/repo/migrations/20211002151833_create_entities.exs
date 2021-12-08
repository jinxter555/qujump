defmodule Qujump.Repo.Migrations.CreateEntities do
  use Ecto.Migration

  def change do
    create table(:entities) do
      add :type, :integer
      # add :parent_id, :integer
      add :parent_id, references(:entities, on_delete: :nothing)
      timestamps()
    end

    create index(:entities, [:parent_id])
    create index(:entities, [:type])
  end
end
