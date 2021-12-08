defmodule QujumpWeb.TodoLive.FormComponent do
  use QujumpWeb, :live_component
  alias Qujump.Work.Todo
  alias Qujump.Work

  @impl true
  def update(%{todo: todo} = assigns, socket) do
    employees = Work.get_employees(todo)
    changeset = Work.change_todo(todo) 
    {:ok,
      socket
      |> assign(assigns)
      |> assign(:changeset, changeset)
      |> assign(:employees, employees)
    }
  end

  @impl true
  def handle_event("validate", %{"todo" => todo_params}, socket) do
    changeset = 
      socket.assigns.todo
      |> Work.change_todo(todo_params)
      |> Map.put(:action, :validate)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"todo" => todo_params}, socket) do
    save_todo(socket, socket.assigns.action, todo_params)
  end

  defp save_todo(socket, :edit, todo_params) do
    attrs = QujumpWeb.CoreHelper.setup_todo_save_params(socket, todo_params)
    Work.update_todo(socket.assigns.todo, attrs) 
    |> case do
      {:ok, _todo} ->
        {:noreply,
          socket
          |> put_flash(:info, "Todo updated successfully")
          |> push_redirect(to: socket.assigns.return_to) }
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_todo(socket, :new, todo_params) do
    QujumpWeb.CoreHelper.setup_todo_save_params(socket, todo_params)
    |> Work.create_todo() 
    |> case do
      {:ok, _todo} ->
        {:noreply,
        socket
        |> put_flash(:info, "Todo created successfully")
        |> push_redirect(to: socket.assigns.return_to)}
      {:error, %Todo{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end


end
