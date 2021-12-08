defmodule Qujump.Employees do
  @moduledoc """
  The Organizations context.
  """

  import Ecto.Query, warn: false
  alias Qujump.Repo

  alias Qujump.Organizations.Employee
  alias Ecto.Multi
  alias Qujump.Entities
  alias Qujump.Entities.EntityMember
  alias Qujump.Accounts
  alias Qujump.Orgstructs


  @doc """
  Returns the list of employees.

  ## Examples

      iex> list_employees()
      [%Employee{}, ...]

  """
  def list_employees do
    Repo.all(Employee)
  end

  @doc """
  Returns the list of employees.

  ## Examples

      iex> list_employees(:orgstruct_id: orgstruct_id)
      [%Employee{}, ...]

  """
  def list_employees(orgstruct_id: orgstruct_id) do
    query = from emp in Employee,
      where: emp.orgstruct_id == ^orgstruct_id,
      select: emp
    Repo.all(query)
  end

  @doc """
  Returns the list of employees.

  ## Examples

      iex> list_employee_members(:orgstruct_id: orgstruct_id)
      [%Employee{}, ...]

  """
  def list_employee_members(orgstruct_id: orgstruct_id) do
    orgstruct = Orgstructs.get_orgstruct!(orgstruct_id)

    #query1 = from em in EntityMember,
    #  where: em.entity_id == ^orgstruct.entity_id

    query = from emp in Employee,
      join: em in EntityMember,
      on: em.member_id == emp.entity_id,
      where: em.entity_id == ^orgstruct.entity_id,
    select: {emp, em.id}

    Repo.all(query)
    
  end

  @doc """
  Gets a single employee.

  Raises `Ecto.NoResultsError` if the Employee does not exist.

  ## Examples

      iex> get_employee!(123)
      %Employee{}

      iex> get_employee!(456)
      ** (Ecto.NoResultsError)

  """
  def get_employee!(id), do: Repo.get!(Employee, id)

  def get_employee_entity_id!(id) do  
    employee = get_employee!(id) 
    employee.entity_id
  end

  def get_employee_by_entity_id!(entity_id) do  
    query = from emp in Employee, where: emp.entity_id == ^entity_id, select: emp
    Repo.all(query)
  end


  @doc """
  Creates a employee.

  ## Examples

      iex> create_employee(%{field: value})
      {:ok, %Employee{}}

      iex> create_employee(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_employee(attrs \\ %{}) do
    %Employee{} |> Employee.changeset(attrs) |> Repo.insert()

  end

  @doc """
  Creates an employee account.
  user has already an email address and id after signup.
  user_id is from users table. 
  # probabaly has to add admin_id who creates account
  # and orgstruct_id if presence

  ## Examples

      iex> create_account(%{user_id: user_id, ...})
      {:ok, %Employee{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_account(%{user_id: integer}) :: {atom(), %Employee{}}
  def create_account(%{user_id: user_id} = attrs) do
    # create_account_multi(user_id) |> Qujump.Repo.transaction()
    {:ok, steps} = create_account_multi(user_id, attrs) |> Qujump.Repo.transaction()
    {:ok, steps.last_step}
  end


  defp create_account_multi(user_id, attrs) do
    Multi.new()
    |> Multi.run(:retrieve_account_user_step, tr_retrieve_account_user(user_id, attrs))
    |> Multi.run(:create_employee_entity_step, &tr_create_employee_entity/2)
    |> Multi.run(:last_step, &tr_create_employee/2)
  end

  defp tr_retrieve_account_user(user_id, attrs) do
    fn _repo, _ ->
      try do
        case Accounts.get_user!(user_id)  do
          user -> {:ok, {user, attrs}}
        end
      rescue
        Ecto.NoResultsError -> {:error, :account_not_found}
      end
    end
  end

  defp tr_create_employee_entity(_repo, %{retrieve_account_user_step: {user, attrs}}) do
    #IO.inspect "create_employee_entity: user.id: #{user.id}"
    case Entities.create_entity(%{type: :employee}) do
      {:ok, employee_entity} -> {:ok, {user, attrs, employee_entity}}
      {:error, _} -> {:error, :cannot_create_employee_entity}
    end
  end

  defp tr_create_employee(_repo, %{create_employee_entity_step: {user, attrs, employee_entity}}) do
    name = if Map.has_key?(attrs, :name) do
      attrs.name
    else
       hd(String.split(user.email, "@"))
    end

    # construct new attrs, with name, validate orgstruct_id if 
    #  present and verify admin_id authorization access if present 
    # lookup attrs.orgstruct_id, if not valid

    Map.merge(%{name: name, user_id: user.id, entity_id: employee_entity.id}, attrs)
    |> create_employee()
    |> case do
      {:ok, employee} -> {:ok, employee}
      {:error, changeset} -> {:error, {:cannot_create_an_employee, changeset.errors}}
    end
  end

  #defp _tr_create_employee_bak(_repo, %{create_employee_entity_step: {user, _attrs, employee_entity}}) do
  #  name = hd(String.split(user.email, "@"))
  #
  #  case create_employee(%{name: name, user_id: user.id, entity_id: employee_entity.id}) do
  #    {:ok, employee} -> {:ok, employee}
  #    {:error, changeset} -> {:error, {:cannot_create_an_employee, changeset.errors}}
  #  end
  #end


  @doc """
  Updates a employee.

  ## Examples

      iex> update_employee(employee, %{field: new_value})
      {:ok, %Employee{}}

      iex> update_employee(employee, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_employee(%Employee{} = employee, attrs) do
    employee
    |> Employee.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a employee.

  ## Examples

      iex> delete_employee(employee)
      {:ok, %Employee{}}

      iex> delete_employee(employee)
      {:error, %Ecto.Changeset{}}

  """
  def delete_employee(%Employee{} = employee) do
    Repo.delete(employee)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking employee changes.

  ## Examples

      iex> change_employee(employee)
      %Ecto.Changeset{data: %Employee{}}

  """
  def change_employee(%Employee{} = employee, attrs \\ %{}) do
    Employee.changeset(employee, attrs)
  end

end
