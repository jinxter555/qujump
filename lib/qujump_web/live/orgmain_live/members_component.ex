defmodule MembersComponent do
  use QujumpWeb, :live_component
  alias Qujump.Orgstructs
  alias Qujump.Employees
  alias Qujump.Entities
  #alias Qujump.Organizations.Employee

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

    {employees, members } = if orgstruct do
      # may need employees_orgstruct_id: to replace parent
      orgstruct_parent = Orgstructs.get_orgstruct_parent!(orgstruct_id)
      { Employees.list_employees(orgstruct_id: orgstruct_parent.id),
        Employees.list_employee_members(orgstruct_id: orgstruct.id)}
    else 
      {[],[]}
    end

    {:ok,                                                                       
      socket    
      |> assign(:members,  members)
      |> assign(:employees,  employees)
      |> assign(:orgstruct, orgstruct)
      |> assign(:member_action, :nil)
      |> assign(assigns)    
    }
  end    

  @impl true
  def update(_assigns, socket) do    
      orgstruct_id = socket.assigns.orgstruct.id
      update(%{orgstruct_id: orgstruct_id}, socket)
  end

  @impl true
  def handle_event("add", %{"id" => employee_id} = _employee_params, socket) do
    orgstruct_id = socket.assigns.orgstruct.id

    try do
      Orgstructs.insert_orgstruct_member(orgstruct_id, employee_id)
    rescue
      e -> IO.inspect "add member fail: #{e.message}"
    end

    members =   Employees.list_employee_members(orgstruct_id: orgstruct_id)

    {:noreply, socket
    |> assign(:page_title, "New Employee")
    |> assign(:members, members)
    }
  end

  @impl true
  def handle_event("delete", %{"id" => em_id} = _member_params, socket) do
    orgstruct_id = socket.assigns.orgstruct.id
    member = Entities.get_entity_member!(em_id)

    {:ok, _} = Entities.delete_entity_member(member)
    members =   Employees.list_employee_members(orgstruct_id: orgstruct_id)
    {:noreply, socket
    |> assign(:members, members)
    }
  end

  def handle_info(:reset, socket) do
    {:noreply, socket
    |> assign(:member_action, nil)
    }
  end

end
