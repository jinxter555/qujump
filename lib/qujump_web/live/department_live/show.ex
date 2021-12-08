defmodule QujumpWeb.DepartmentLive.Show do
  use QujumpWeb, :live_view

  alias Qujump.Companies

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:department, Companies.get_department!(id))}
  end

  defp page_title(:show), do: "Show Department"
  defp page_title(:edit), do: "Edit Department"
end
