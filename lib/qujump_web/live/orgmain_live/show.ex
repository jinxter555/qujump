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
    nested_orgstruct = Orgstructs.build_nested_orgstruct(orgstruct.id)

    display_employees =
      params["display_employees"]
      |> bool || false

    display_orgstruct_members =
      params["display_employees"]
      |> bool || false

    return_to = params["return_to"] || 
      Routes.orgmain_show_path(socket,
        :show, orgstruct,
        display_employees: display_employees)

    {:noreply,
      socket
      |> assign(:pagetitle, page_title(socket.assigns.live_action))
      |> assign(:display_employees, display_employees)
      |> assign(:display_orgstruct_members, display_orgstruct_members)
      |> assign(:return_to, return_to)
      |> assign(:orgstruct, orgstruct)
      |> assign(:nested_orgstruct, nested_orgstruct)
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
    display_orgstruct_members = !socket.assigns.display_orgstruct_members

    orgstruct = socket.assigns.orgstruct

    return_to = Routes.orgmain_show_path(socket, :show, 
      orgstruct, display_orgstruct_members: display_orgstruct_members)

    {:noreply,
      socket
      |> assign(:return_to, return_to)
      |> assign(:display_orgstruct_members, !socket.assigns.display_orgstruct_members)
    }


  end
       
  defp list_nested_orgstruct(assigns) do
    ~H"""
      <%= for child <- @nested_orgstruct.children do %> <br/>
        <%= child.name %>
        <%= child.entity_id %>
        <%= child.entity.parent_id %>
        <%= if Map.has_key?(child, :children) do  %>
          <.list_nested_orgstruct nested_orgstruct={child} />
        <% end %>
      <% end %>
    """
  end

  defp page_title(:show), do: "Show Orgstruct"                                 
  def bool("true"), do: true
  def bool("false"), do: false
  def bool(_), do: false

end
