defmodule Qujump.Organizations.Employee do
  use Ecto.Schema
  import Ecto.Changeset
  alias Qujump.Accounts.User
  alias Qujump.Organizations.Orgstruct
  alias Qujump.Entities.Entity

  schema "employees" do
    field :name, :string
    field :title, :integer

    belongs_to :orgstruct, Orgstruct
    belongs_to :user, User
    belongs_to :entity, Entity


    timestamps()
  end

  @doc false
  def changeset(employee, attrs) do
    employee
    |> cast(attrs, [:name, :orgstruct_id, :title, :user_id, :entity_id])
    # |> validate_required([:name, :title])
    |> validate_required([:name])
    |> cast_assoc(:orgstruct)
    |> cast_assoc(:user)
    |> cast_assoc(:entity)
    |> validate_required([:name])
  end
end
