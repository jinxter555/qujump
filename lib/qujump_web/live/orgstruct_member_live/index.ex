defmodule QujumpWeb.OrgstructMemberLive.Index do
  use QujumpWeb, :live_view

  alias Qujump.Orgstructs

  on_mount QujumpWeb.AuthUser

  @impl true
  def mount(%{"orgstruct_id" => orgstruct_id} = _params, _session, socket) do
    {:ok,
      socket
      |> assign(:orgstruct_members, 
        Orgstructs.list_members_by_orgstruct_id(orgstruct_id))
      |> assign(:orgstruct, Orgstructs.get_orgstruct!(orgstruct_id))
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
     {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, %{"orgstruct_id" => orgstruct_id} = _params) do
    IO.inspect socket
    socket
    |> assign(:page_title, "New org member")
    |> assign(:orgstruct_id, orgstruct_id)
  end

   defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Companies")
  end


end
