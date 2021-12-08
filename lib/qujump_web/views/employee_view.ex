defmodule QujumpWeb.EmployeeView do
  use QujumpWeb, :view

  def employee_name_not_good(entity_id) do
    employee = hd Qujump.Employee.get_employee_by_entity_id!(entity_id)
    employee.name
  end
end
