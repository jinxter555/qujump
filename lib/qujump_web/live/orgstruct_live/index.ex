defmodule QujumpWeb.OrgstructLive.Index do
  use QujumpWeb, :live_view

  alias Qujump.Organizations.Orgstruct
  alias Qujump.Orgstructs

  on_mount QujumpWeb.AuthUser

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> assign(:orgstructs, list_orgstructs())
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
      apply_action(socket, socket.assigns.live_action, params)
    }
  end

  defp apply_action(socket, :edit, %{"id"=> id} = params) do
    return_to = params["return_to"] ||
      Routes.orgstruct_index_path(socket, :index)
    socket
    |> assign(:page_title, "index edit orgstruct")
    |> assign(:orgstruct, Orgstructs.get_orgstruct!(id))
    |> assign(:return_to, return_to)
  end

  defp apply_action(socket, :new, %{"orgstruct_id" => orgstruct_id } = params) do
    type = String.to_atom(params["type"])
      
    return_to = params["return_to"] ||
      Routes.orgstruct_index_path(socket, :index)

    parent_orgstruct = 
      Orgstructs.get_orgstruct!(orgstruct_id) 

    socket
    |> assign(:page_title, "New Hier #{type} Org")
    |> assign(:orgstruct, %Orgstruct{type: type})
    |> assign(:parent_orgstruct, parent_orgstruct)
    |> assign(:return_to, return_to)
  end

  defp apply_action(socket, :new, params) do
    type = String.to_atom(params["type"])

    return_to = params["return_to"] ||
      Routes.orgstruct_index_path(socket, :index)

    socket
    |> assign(:page_title, "New Org")
    |> assign(:orgstruct, %Orgstruct{type: type})
    |> assign(:parent_orgstruct, nil)
    |> assign(:return_to, return_to)
  end


  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "listing orgstructs")
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    orgstruct = Orgstructs.get_orgstruct!(id) 
                |> Qujump.Repo.preload(:entity)
    {:ok, _} = Orgstructs.delete_orgstruct(orgstruct)
    {:noreply,
      socket
      |> assign(:orgstructs, list_orgstructs())
      |> put_flash(:info, "orgstruct deleted succeffully")
    }
  end

  defp list_orgstructs do
    Orgstructs.list_orgstructs()
  end
end
