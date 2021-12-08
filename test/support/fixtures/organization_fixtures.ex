defmodule Qujump.OrganizationFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Qujump.Organization` context.
  """

  @doc """
  Generate a employee.
  """
  def employee_fixture(attrs \\ %{}) do
    {:ok, employee} =
      attrs
      |> Enum.into(%{
        name: "some name",
        org_entity_id: 42,
        title: 42
      })
      |> Qujump.Employees.create_employee()

    employee
  end

  @doc """
  Generate a orgstruct.
  """
  def orgstruct_fixture(attrs \\ %{}) do
    {:ok, orgstruct} =
      attrs
      |> Enum.into(%{
        name: "some name",
        type: :company
      })
      |> Qujump.Orgstructs.create_orgstruct()

    orgstruct
  end
end
