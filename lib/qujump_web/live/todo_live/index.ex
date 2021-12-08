defmodule QujumpWeb.TodoLive.Index do
  use QujumpWeb, :live_view

  alias Qujump.Work
  alias Qujump.Work.Todo

  on_mount QujumpWeb.AuthUser

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :todos, list_todos())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing")
    |> assign(:todo, nil)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Todo")
    |> assign(:todo, %Todo{type: :task})
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Todo")
    |> assign(:todo, Work.get_todo!(id))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    todo = Work.get_todo!(id)
    {:ok, _} = Work.delete_todo(todo)
    {:noreply, assign(socket, :todos, list_todos())}
  end


  def list_todos() do
    Work.list_todos()
  end

end
