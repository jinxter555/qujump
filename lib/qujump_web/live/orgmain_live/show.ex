defmodule QujumpWeb.OrgmainLive.Show do
  use QujumpWeb, :live_view
  alias Qujump.Orgstructs

  on_mount QujumpWeb.AuthUser
  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"orgstruct_id" => orgstruct_id}, _, socket) do                        

    {:noreply,
      socket
      |> assign(:pagetitle, page_title(socket.assigns.live_action))
      |> assign(:orgstruct, Orgstructs.get_orgstruct!(orgstruct_id))}
  end

  @impl true
  def handle_event("list_employees", _, socket) do
    live_action = if socket.assigns.live_action == :list_employees,
      do: nil,
    else: :list_employees

    {:noreply,
      socket
      |> assign(:live_action, live_action)}
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

end
