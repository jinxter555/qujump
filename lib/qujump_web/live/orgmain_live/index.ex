defmodule QujumpWeb.OrgmainLive.Index do
  use QujumpWeb, :live_view
  alias Qujump.Orgstructs
  #alias Qujump.Employees

      
  on_mount QujumpWeb.AuthUser

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> assign(:orgstructs, list_orgstructs())
      |> assign(:employees, [])
      |> assign(:orgstruct, nil)}

  end
  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
      apply_action(socket, socket.assigns.live_action, params)
    }
  end

  defp apply_action(socket, :index, _params) do    
    socket    
  end    

  @impl true    
  def handle_event("list_employees", %{"id" => id}, socket) do    
    list_orgstruct(id, socket) 
  end    
    
  @impl true    
  def handle_event("list_orgstruct_members", %{"id" => id}, socket) do    
    list_orgstruct(id, socket) 
  end    

  defp list_orgstruct(id, socket) do
    orgstruct = Orgstructs.get_orgstruct!(id)
    {:noreply, 
      socket
      |> assign(:orgstruct, orgstruct)}
  end                    

  defp list_orgstructs do
    Orgstructs.list_orgstructs()
  end                    
end
