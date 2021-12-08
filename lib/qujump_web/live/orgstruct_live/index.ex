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

  defp apply_action(socket, :edit, %{"id"=> id}) do
    socket
    |> assign(:page_title, "index edit orgstruct")
    |> assign(:orgstruct, Orgstructs.get_orgstruct!(id))
  end

  defp apply_action(socket, :new, %{"orgstruct_id" => orgstruct_id } = params) do
    type = String.to_atom(params["type"])
    parent_orgstruct = 
      Orgstructs.get_orgstruct!(orgstruct_id) 
      |> Qujump.Repo.preload([:entity])

    socket
    |> assign(:page_title, "New Hier #{type} Org")
    |> assign(:orgstruct, %Orgstruct{type: type})
    |> assign(:parent_entity_id, parent_orgstruct.entity.id)
  end

  defp apply_action(socket, :new, params) do
    type = String.to_atom(params["type"])
    socket
    |> assign(:page_title, "New Org")
    |> assign(:orgstruct, %Orgstruct{type: type})
    |> assign(:parent_entity_id, nil)
  end


  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "listing orgstructs")
  end

  @impl true
  def handle_event("delete", %{"id" =>id}, socket) do
    orgstruct = Orgstructs.get_orgstruct!(id) |> Qujump.Repo.preload([:entity])
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
