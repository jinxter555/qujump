defmodule Qujump.Repo.Migrations.CreateEmployees do
  use Ecto.Migration

  def change do
    create table(:employees) do
      add :name, :string
      add :orgstruct_id, :integer
      add :entity_id, :integer
      add :title, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:employees, [:name])
    create index(:employees, [:orgstruct_id])
    create index(:employees, [:entity_id])
    create index(:employees, [:title])
    create index(:employees, [:user_id])
  end
end
