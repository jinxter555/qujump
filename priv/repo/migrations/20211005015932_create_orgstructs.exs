defmodule Qujump.Repo.Migrations.CreateOrgstructs do
  use Ecto.Migration

  def change do
    create table(:orgstructs) do
      add :name, :string
      add :type, :integer
      add :entity_id, :integer
      add :leader_entity_id, references(:entities, on_delete: :nothing)

      timestamps()
    end

    create index(:orgstructs, [:leader_entity_id])
  end
end
