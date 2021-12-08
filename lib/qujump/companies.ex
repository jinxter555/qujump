defmodule Qujump.Companies do
  @moduledoc """
  The Companies context.
  """

  import Ecto.Query, warn: false
  alias Qujump.Repo

  alias Qujump.Organizations.Orgstruct
  #alias Qujump.Organizations.Orgstruct, as: Company
  #alias Qujump.Organizations.Orgstruct, as: Department

  #alias Qujump.Companies.Company
  #alias Qujump.Companies.Department
 
  import Ecto.Query, only: [from: 2]



  @doc """
  Returns the list of companies.

  ## Examples

      iex> list_companies()
      [%Company{}, ...]

  """
  def list_companies do
    # Repo.all(Company)
    query = from org in Orgstruct, where: org.type == :company, select: org
    Repo.all(query)
  end

  @doc """
  Gets a single company aka Orgstruct.

  Raises `Ecto.NoResultsError` if the Company does not exist.

  ## Examples

      iex> get_company!(123)
      %Orgstruct{}

      iex> get_company!(456)
      ** (Ecto.NoResultsError)

  """
  def get_company!(id) do  
    Repo.get!(Orgstruct, id)
  end

  @doc """
  Creates a company.

  ## Examples

      iex> create_company(%{field: value})
      {:ok, %Company{}}

      iex> create_company(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company(attrs \\ %{}) do
    # %Orgstruct{type: :company}
    #|> Orgstruct.changeset(attrs)
    #|> Repo.insert()
    #%Company{}
    #|> Company.changeset(attrs)
    #|> Repo.insert()
    Map.merge(attrs, %{type: :company}) |> Qujump.Orgstructs.create_orgstruct()
  end

  @doc """
  Updates a company.

  ## Examples

      iex> update_company(company, %{field: new_value})
      {:ok, %Company{}}

      iex> update_company(company, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company(%Orgstruct{} = orgstruct, attrs) do
    orgstruct
    |> Orgstruct.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a company.

  ## Examples

      iex> delete_company(company)
      {:ok, %Company{}}

      iex> delete_company(company)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company(%Orgstruct{} = orgstruct) do
    Repo.delete(orgstruct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company changes.

  ## Examples

      iex> change_company(company)
      %Ecto.Changeset{data: %Company{}}

  """
  def change_company(%Orgstruct{} = orgstruct, attrs \\ %{}) do
    Orgstruct.changeset(orgstruct, attrs)
  end


  @doc """
  Returns the list of departments.

  ## Examples

      iex> list_departments()
      [%Department{}, ...]

  """
  def list_departments do
    query = from org in Orgstruct, where: org.type == :department, select: org
    Repo.all(query)
  end

  @doc """
  Gets a single department.

  Raises `Ecto.NoResultsError` if the Department does not exist.

  ## Examples

      iex> get_department!(123)
      %Department{}

      iex> get_department!(456)
      ** (Ecto.NoResultsError)

  """
  def get_department!(id), do: Repo.get!(Orgstruct, id)

  @doc """
  Creates a department.

  ## Examples

      iex> create_department(%{field: value})
      {:ok, %Department{}}

      iex> create_department(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_department(attrs \\ %{}) do
    #%Department{}
    #|> Department.changeset(attrs)
    #|> Repo.insert()
    Map.merge(attrs, %{type: :department}) |> Qujump.Orgstructs.create_orgstruct()
  end

  @doc """
  Updates a department.

  ## Examples

      iex> update_department(department, %{field: new_value})
      {:ok, %Department{}}

      iex> update_department(department, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_department(%Orgstruct{} = orgstruct, attrs) do
    orgstruct
    |> Orgstruct.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a department.

  ## Examples

      iex> delete_department(department)
      {:ok, %Department{}}

      iex> delete_department(department)
      {:error, %Ecto.Changeset{}}

  """
  def delete_department(%Orgstruct{} = orgstruct) do
    Repo.delete(orgstruct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking department changes.

  ## Examples

      iex> change_department(department)
      %Ecto.Changeset{data: %Department{}}

  """
  def change_department(%Orgstruct{} = orgstruct, attrs \\ %{}) do
    Orgstruct.changeset(orgstruct, attrs)
  end
end
