defmodule Qujump.Organizations.Orgstruct do
  use Ecto.Schema
  import Ecto.Changeset

  alias Qujump.Organizations.Employee
  alias Qujump.Entities.Entity


  # defenum OrgType, corporate_group: 100, company: 101, department: 102

  schema "orgstructs" do
    field :name, :string
    field :type, Ecto.Enum, values: [corporate_group: 100, company: 101, department: 102, team: 103, league: 104]
    belongs_to :leader_entity, Entity
    belongs_to :entity, Entity

    has_many :employees, Employee

    timestamps()
  end

  @doc false
  def changeset(orgstruct, attrs) do
    orgstruct
    |> cast(attrs, [:name, :type])
    |> cast_assoc(:entity)
    |> cast_assoc(:leader_entity)
    |> validate_required([:name, :type])
  end
end
