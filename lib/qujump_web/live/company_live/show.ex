defmodule QujumpWeb.CompanyLive.Show do
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
     |> assign(:content, "helo world")
     |> assign(:company, Companies.get_company!(id))}
  end

  defp page_title(:show), do: "Show Company"
  defp page_title(:edit), do: "show Edit Company"
end
