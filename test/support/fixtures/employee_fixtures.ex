defmodule Qujump.EmployeeFixtures do
  import Qujump.Factory

  @moduledoc """
  This module defines test helpers for creating
  entities via the `Qujump.Work` context.
  """

  @doc """
  Generate a todo.
  """
  def employee_fixture(_attrs \\ %{}) do
    insert(:employee)
  end
end
