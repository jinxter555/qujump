defmodule QujumpWeb.TodoLive.Show do
  use QujumpWeb, :live_view

  alias Qujump.Work
  # alias Qujump.Accounts


  on_mount QujumpWeb.AuthUser


  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    {:noreply,
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:todo, Work.get_todo!(id) |> Qujump.Repo.preload([:assignto_entity]))}
  end


  defp page_title(:show), do: "Show Todo"
  defp page_title(:edit), do: "Edit Todo"

end
