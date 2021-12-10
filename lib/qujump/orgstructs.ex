defmodule Qujump.Orgstructs do
  @moduledoc """
  The Organizations context.
  """

  import Ecto.Query, warn: false
  alias Qujump.Repo
  alias Qujump.Employees
  alias Qujump.Entities
  alias Qujump.Entities.Entity


  alias Qujump.Organizations.Orgstruct

  @doc """
  Returns the list of orgstruct.

  ## Examples

      iex> list_orgstructs()
      [%Orgstruct{}, ...]

  """
  def list_orgstructs do
    Repo.all(Orgstruct)
  end

  @doc """
  Gets a single orgstruct.

  Raises `Ecto.NoResultsError` if the Orgstruct does not exist.

  ## Examples

      iex> get_orgstruct!(123)
      %Orgstruct{}

      iex> get_orgstruct!(456)
      ** (Ecto.NoResultsError)

  """
  def get_orgstruct!(id), do: Repo.get!(Orgstruct, id)
  def get_orgstruct_entity_id!(id) do
    o = get_orgstruct!(id)
    o.entity_id
  end
  def get_orgstruct_parent!(id) do
    parent_entity = get_orgstruct!(id) |> Repo.preload([entity: :parent])

    query = from org in Orgstruct,
      where: org.entity_id == ^parent_entity.id

    hd Repo.all(query)
  end

  def get_orgstruct_with_members!(id) do
    get_orgstruct!(id) |> Repo.preload([entity: :members])
  end

  @doc """
  Creates an organization structure.

  ## Examples
  ## create_orgstruct(%{employee_id, name, type: [:company | :department | :corporate_group]})
  
      iex> create_orgstruct(%{employee_id: 123, name: "my company", type: :company}, parent_orgstruct_id \\ nil)
      {:ok, %Employee{}}

      iex> create_orgstruct(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_orgstruct(%{employee_id: integer, name: String.t(), type: atom()}) :: {atom(), %Orgstruct{}}
  def create_orgstruct(%{employee_id: employee_id, name: name, type: type} = _attr, parent_orgstruct_id \\ nil) do

    Repo.transaction(fn ->
      employee = Employees.get_employee!(employee_id)  |> Repo.preload([:orgstruct, :entity])

      parent_entity_id = 
        if parent_orgstruct_id do 
          IO.puts "parent orgstruct id: "
          IO.inspect parent_orgstruct_id
          get_orgstruct_entity_id!(parent_orgstruct_id)
        else 
          nil
        end

      # add parent org
      {:ok, entity} = Entities.create_entity(%{type: :org, parent_id: parent_entity_id})

      orgstruct = %Orgstruct{name: name, type: type}
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_assoc(:entity, entity)
      |> Ecto.Changeset.put_assoc(:leader_entity, employee.entity)
      |> Repo.insert!()

      if employee.orgstruct == nil do
        employee
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.put_assoc(:orgstruct, orgstruct)
        |> Repo.update!()
      end
      orgstruct
    end)
  end


  @doc """
  Updates a orgstruct.

  ## Examples

      iex> update_orgstruct(orgstruct, %{field: new_value})
      {:ok, %Orgstruct{}}

      iex> update_orgstruct(orgstruct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_orgstruct(%Orgstruct{} = orgstruct, attrs) do
    orgstruct
    |> Orgstruct.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a orgstruct.

  ## Examples

      iex> delete_orgstruct(orgstruct)
      {:ok, %Orgstruct{}}

      iex> delete_orgstruct(orgstruct)
      {:error, %Ecto.Changeset{}}

  """
  def delete_orgstruct(%Orgstruct{} = orgstruct) do
    Repo.transaction(fn ->
      Repo.delete(orgstruct.entity)
      Repo.delete(orgstruct)
    end)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking orgstruct changes.

  ## Examples

      iex> change_orgstruct(orgstruct)
      %Ecto.Changeset{data: %Orgstruct{}}

  """
  def change_orgstruct(%Orgstruct{} = orgstruct, attrs \\ %{}) do
    Orgstruct.changeset(orgstruct, attrs)
  end


  def list_members(id) do
    orgstruct = get_orgstruct_with_members!(id)
    orgstruct.entity.members
  end

  def list_children(id) do
    orgstruct = get_orgstruct!(id)
    
    query = from org in Orgstruct,
     join: e in Entity, 
      on: e.id == org.entity_id,
      where: e.parent_id == ^orgstruct.entity_id

    Repo.all(query)

  end

  def build_nested_children(orgmap, id) do
    orgmap  = if orgmap==%{}, do: get_orgstruct!(id) |>Map.from_struct()
    children = list_children(id)
  end

  defp org_id_name_type(orgstruct) do
    %{}
  end



  def insert_orgstruct_member(orgstruct_id, employee_id) do
    employee_entity_id = Employees.get_employee_entity_id!(employee_id)
    orgstruct_entity_id = get_orgstruct_entity_id!(orgstruct_id)
    Entities.create_entity_member(%{
      entity_id: orgstruct_entity_id,
      member_id: employee_entity_id})
  end

end


