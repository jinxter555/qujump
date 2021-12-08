defmodule Qujump.OrgstructFixtures do
  import Qujump.Factory
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Qujump.Companies` context.
  """

  @doc """
  Generate a company.
  """

  def company_fixture(_attrs \\ %{}) do
    #user = Qujump.AccountsFixtures.user_fixture()
    #{:ok, employee} = Qujump.Employee.create_account(user.id)
    #{:ok, company} =
    #  attrs
    #  |> Enum.into(%{
    #    name: Faker.Company.name(),
    #    employee_id: employee.id
    #  })
    #  |> Qujump.Companies.create_company()

    #company
    insert(:company)
  end

  @doc """
  Generate a department.
  """
  def department_fixture(_attrs \\ %{}) do
    #company = company_fixture()
    #{:ok, department} =
    #  attrs
    #  |> Enum.into(%{
    #    company_id: company.id,
    #    name: "some name"
    #  })
    #  |> Qujump.Companies.create_department()

    insert(:department)
  end
end
