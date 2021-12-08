defmodule Qujump.CompaniesTest do
  use Qujump.DataCase

  alias Qujump.Companies

  describe "companies" do
    # alias Qujump.Companies.Company
    alias Qujump.Organizations.Orgstruct, as: Company

    import Qujump.OrgstructFixtures
    import Qujump.EmployeeFixtures

    @invalid_attrs %{}

    test "list_companies/0 returns all companies" do
      company = company_fixture() |>  Qujump.Repo.preload([:entity, :leader_entity])
      assert Companies.list_companies()  |> Qujump.Repo.preload([:entity, :leader_entity])== [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture() |>  Qujump.Repo.preload([:entity, :leader_entity]) 
      assert Companies.get_company!(company.id)  |> Qujump.Repo.preload([:entity, :leader_entity]) == company
    end


    test "create_company/1 with valid data creates a company" do
      employee = employee_fixture()
      valid_attrs = %{name: Faker.Company.name(), employee_id: employee.id}
      assert {:ok, %Company{} = _company} = Companies.create_company(valid_attrs)
    end


    #@tag :skip
    #test "create_company/1 with invalid data returns error changeset" do
    #  employee = employee_fixture()
    #  invalid_attrs = %{employee_id: employee.id, name: nil, type: :company}
    #  assert {:error, %Ecto.Changeset{}} = Companies.create_company(invalid_attrs)
    #end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      update_attrs = %{}
      assert {:ok, %Company{} = _company} = Companies.update_company(company, update_attrs) 
    end

    test "update_company/2 with invalid data returns error changeset" do
      
      invalid_attrs = %{name: nil}
      company = company_fixture()  |> Qujump.Repo.preload([:entity, :leader_entity]) 
      assert {:error, %Ecto.Changeset{}} = Companies.update_company(company, invalid_attrs)
      assert company == Companies.get_company!(company.id)  |> Qujump.Repo.preload([:entity, :leader_entity]) 
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Companies.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Companies.change_company(company)
    end
  end


  describe "departments" do
    # alias Qujump.Companies.Department
    alias Qujump.Organizations.Orgstruct, as: Department

    import Qujump.OrgstructFixtures
    import Qujump.EmployeeFixtures

    @invalid_attrs %{name: nil}


    test "list_departments/0 returns all departments" do
      department = department_fixture()  
                   |> Qujump.Repo.preload([:entity, :leader_entity]) 
      assert Companies.list_departments()  
      |> Qujump.Repo.preload([:entity, :leader_entity]) 
      == [department]
    end

    test "get_department!/1 returns the department with given id" do
      department = department_fixture()
                   |> Qujump.Repo.preload([:entity, :leader_entity]) 

      assert Companies.get_department!(department.id) 
                   |> Qujump.Repo.preload([:entity, :leader_entity]) 
                   == department
    end

    test "create_department/1 with valid data creates a department" do
      employee = employee_fixture()
      valid_attrs = %{name: "some name", employee_id: employee.id}
      assert {:ok, %Department{} = department} = Companies.create_department(valid_attrs)
      assert department.name == "some name"
    end

    #test "create_department/1 with invalid data returns error changeset" do
    #  employee = employee_fixture()
    #  invalid_attrs = %{name: nil, employee_id: employee.id}
    #  assert {:error, %Ecto.Changeset{}} = Companies.create_department(invalid_attrs)
    #end

    test "update_department/2 with valid data updates the department" do
      department = department_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Department{} = department} = Companies.update_department(department, update_attrs)
      assert department.name == "some updated name"
    end

    test "update_department/2 with invalid data returns error changeset" do
      department = department_fixture() 
      |> Qujump.Repo.preload([:entity, :leader_entity])

      assert {:error, %Ecto.Changeset{}} = Companies.update_department(department, @invalid_attrs)

      assert department == Companies.get_department!(department.id)
      |> Qujump.Repo.preload([:entity, :leader_entity])
    end

    test "delete_department/1 deletes the department" do
      department = department_fixture()
      assert {:ok, %Department{}} = Companies.delete_department(department)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_department!(department.id) end
    end

    test "change_department/1 returns a department changeset" do
      department = department_fixture()
      assert %Ecto.Changeset{} = Companies.change_department(department)
    end
  end
end
