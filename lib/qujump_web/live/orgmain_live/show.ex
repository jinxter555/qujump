defmodule QujumpWeb.OrgmainLive.Show do
  use QujumpWeb, :live_view
  alias Qujump.Orgstructs

  on_mount QujumpWeb.AuthUser
  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket
    |> assign(:display_employees, false)
    |> assign(:display_orgstruct_members, false)
    }
  end

  @impl true
  def handle_params(%{"orgstruct_id" => orgstruct_id} = params, _, socket) do                        

    orgstruct = Orgstructs.get_orgstruct!(orgstruct_id)

    display_employees = 
      if bool(params["display_employees"]),
        do: bool(params["display_employees"]),
      else: false

    return_to = params["return_to"] || 
      Routes.orgmain_show_path(socket, :show, orgstruct, display_employees: display_employees)

    {:noreply,
      socket
      |> assign(:pagetitle, page_title(socket.assigns.live_action))
      |> assign(:display_employees, display_employees)
      |> assign(:return_to, return_to)
      |> assign(:orgstruct, orgstruct)
    }
  end

  @impl true
  def handle_event("list_employees", _, socket) do
    display_employees = !socket.assigns.display_employees

    orgstruct = socket.assigns.orgstruct

    return_to = Routes.orgmain_show_path(socket, :show, 
      orgstruct, display_employees: display_employees)

    {:noreply,
      socket
      |> assign(:return_to, return_to)
      |> assign(:display_employees, !socket.assigns.display_employees)
    }
  end

  def handle_event("list_orgstruct_members", _, socket) do
    live_action = if socket.assigns.live_action == :list_orgstruct_members,
      do: nil,
    else: :list_orgstruct_members

    {:noreply,
      socket
      |> assign(:live_action, live_action)}

  end
       
  defp page_title(:show), do: "Show Orgstruct"                                 


  def bool("true"), do: true
  def bool("false"), do: false
  def bool(_), do: false

end
