defmodule QujumpWeb.OrgstructLive.Show do
  use QujumpWeb, :live_view
  alias Qujump.Orgstructs

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:orgstruct, Orgstructs.get_orgstruct!(id))}
  end

  defp page_title(:show), do: "Show Orgstruct2"
  defp page_title(:edit), do: "Show edit Company"
end
