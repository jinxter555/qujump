defmodule EmployeesComponent do
  use QujumpWeb, :live_component
  alias Qujump.Orgstructs
  alias Qujump.Employees
  alias Qujump.Organizations.Employee

  @impl true
  def mount(socket) do
    {:ok,
    socket
    }
  end

  @impl true    
  def update(%{orgstruct_id: orgstruct_id} = assigns, socket) do    
    orgstruct = if orgstruct_id, 
      do: Orgstructs.get_orgstruct!(orgstruct_id),
      else: nil

    employees = if orgstruct,
      do: Employees.list_employees(orgstruct_id: orgstruct_id),
    else: []

    {:ok,                                                                       
      socket    
      |> assign(:employees,  employees)
      |> assign(:orgstruct, orgstruct)
      |> assign(:employee_action, :nil)
      |> assign(assigns)    
    }
  end    

  @impl true
  def update(_assigns, socket) do    
      orgstruct_id = socket.assigns.orgstruct.id
      update(%{orgstruct_id: orgstruct_id}, socket)
  end

    
  @impl true
  def handle_event("new", %{"id" => orgstruct_id} = _employee_params, socket) do
    orgstruct = Orgstructs.get_orgstruct!(orgstruct_id)

    {:noreply, socket
    |> assign(:employee, %Employee{orgstruct_id: orgstruct.id})
    |> assign(:employee_action, :new)
    |> assign(:page_title, "New Employee")
    |> assign(:orgstruct, orgstruct)}
  end

  def handle_info(:reset, socket) do
    {:noreply, socket
    |> assign(:employee_action, nil)
    }
  end


end
