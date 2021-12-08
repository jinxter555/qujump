defmodule QujumpWeb.EmployeeLive.FormComponent do
  use QujumpWeb, :live_component
  #alias Qujump.Orgstructs
  alias Qujump.Employees
  alias Qujump.Organizations.Employee

  @impl true
  def update(%{employee: employee} =assigns, socket) do
    changeset = Employees.change_employee(employee)
    {:ok, 
      socket
      |> assign(assigns)
      |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"employee" => employee_params}, socket) do
    changeset = 
      socket.assigns.employee
      |> Employees.change_employee(employee_params)
      |> Map.put(:action, :validate)
    {:noreply, socket |> assign(:changeset, changeset)}
  end

  def handle_event("save", %{"employee" => employee_params}, socket) do
    save_employee(socket, socket.assigns.action, employee_params)
  end

  defp save_employee(socket, :edit, employee_params) do
    attrs = QujumpWeb.CoreHelper.setup_employee_params(socket, employee_params)
    Employees.update_employee(socket.assigns.employee, attrs)
    |> case do
      {:ok, _employee} ->
        {:noreply, socket
        |> put_flash(:info, "employee updated successfully")
        |> push_redirect(to: socket.assigns.return_to)}
      {:error, %Employee{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp save_employee(socket, :new, employee_params) do
    QujumpWeb.CoreHelper.setup_employee_params(socket, employee_params)
    |> Employees.create_employee()
    |> case do
      {:ok, _employee} ->
        {:noreply, socket
        |> put_flash(:info, "employee created successfully")
        |> push_redirect(to: socket.assigns.return_to)}
      {:error, %Employee{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}

    end
  end
end
