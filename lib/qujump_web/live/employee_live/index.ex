defmodule QujumpWeb.EmployeeLive.Index do
  use QujumpWeb, :live_view

  alias Qujump.Employees
  alias Qujump.Organizations.Employee
  alias Qujump.Orgstructs
  alias QujumpWeb.AuthUser


  on_mount AuthUser

  @impl true
  def mount(_params, _session, socket) do
    current_employee = AuthUser.get_current_employee(socket)
    orgstruct = Orgstructs.get_orgstruct!(current_employee.orgstruct_id)
    {:ok, 
      socket
      |> assign(:employees, Employees.list_employees())
      |> assign(:orgstruct, orgstruct)}
  end
     
  @impl true    
  def handle_params(params, _url, socket) do    
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}        
  end    
    
  defp apply_action(socket, :index, _params) do    
    socket
    |> assign(:page_title, "listing employee")
    |> assign(:employee, nil)

  end


  defp apply_action(socket, :new, %{"orgstruct_id" => orgstruct_id} = params) do
    orgstruct = Orgstructs.get_orgstruct!(orgstruct_id)
    return_to = params["return_to"] ||
       Routes.employee_index_path(socket, :index)

    socket
    |> assign(:page_title, "New Employee")
    |> assign(:return_to, return_to)
    |> assign(:employee, %Employee{orgstruct_id: orgstruct_id})
    |> assign(:orgstruct, orgstruct)
  end

  defp apply_action(socket, :edit, %{"id" => id} = params) do
    return_to = params["return_to"] ||
       Routes.employee_index_path(socket, :index)

    socket
    |> assign(:page_title, "Edit Employee" )
    |> assign(:return_to, return_to)
    |> assign(:employee, Employees.get_employee!(id))
  end

  defp apply_action(socket, :list, %{"orgstruct_id" => orgstruct_id} =_params) do
    employees = if orgstruct_id, 
      do: Employees.list_employees(orgstruct_id: orgstruct_id),
      else: Employees.list_employees()
    socket
    |> assign(:page_title, "new employee")
    |> assign(:employees, employees)
    |> assign(:orgstruct, Orgstructs.get_orgstruct!(orgstruct_id))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    #orgstruct_id = 
    #  if Map.has_key?(socket.assigns, :orgstruct_id) do
    #    socket.assigns.orgstruct_id
    #  else
    #    nil
    #  end

    #employees = if orgstruct_id,
    #  do: Employees.list_employees(orgstruct_id: orgstruct_id),
    #  else: Employees.list_employees()

    employee = Employees.get_employee!(id)
    {:ok, _} = Employees.delete_employee(employee)
      {:noreply, 
        socket
        |> put_flash(:info, "Employee #{employee.name} successfully deleted")
        |> assign(:employees, Employees.list_employees())}

  end

  
end
