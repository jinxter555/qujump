defmodule QujumpWeb.OrgstructLive.FormComponent do
  use QujumpWeb, :live_component
  alias Qujump.Orgstructs
  alias Qujump.Organizations.Orgstruct

  @impl true
  def update(%{orgstruct: orgstruct}  = assigns, socket) do
    changeset = Orgstructs.change_orgstruct(orgstruct)
    {:ok,
      socket
      |> assign(assigns)
      |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"orgstruct" => orgstruct_params}, socket) do
    changeset =
      socket.assigns.orgstruct
      |> Orgstructs.change_orgstruct(orgstruct_params)
      |> Map.put(:action, :validate)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"orgstruct" => orgstruct_params}, socket) do
    save_orgstruct(socket, socket.assigns.action, orgstruct_params)
  end

  defp save_orgstruct(socket, :edit, orgstruct_params) do
    case Orgstructs.update_orgstruct(socket.assigns.orgstruct, orgstruct_params) do
      {:ok, _orgstruct} ->
        {:noreply,
         socket
         |> put_flash(:info, "Orgstruct updated succeffuly")
         |> push_redirect(to: socket.assigns.return_to)}
    end
  end

  defp save_orgstruct(socket, :new, orgstruct_params) do
    IO.inspect socket.assigns

    parent_entity_id = 
      if Map.has_key?(socket.assigns, :parent_entity_id) do
        socket.assigns.parent_entity_id 
      else
        nil
      end

    QujumpWeb.CoreHelper.setup_orgstruct_params(socket, orgstruct_params)
    |> Orgstructs.create_orgstruct(parent_entity_id)
    |> case do
      {:ok, _orgstruct} ->
        {:noreply,
          socket
          |> put_flash(:info, "orgstruct created succeffuly")
          |> push_redirect(to: socket.assigns.return_to)}
      {:error, %Orgstruct{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

end
