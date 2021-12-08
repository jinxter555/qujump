defmodule QujumpWeb.DepartmentLive.Index do
  use QujumpWeb, :live_view

  alias Qujump.Companies
  alias Qujump.Organizations.Orgstruct, as: Department

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :departments, list_departments())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Department")
    |> assign(:department, Companies.get_department!(id))
  end

  defp apply_action(socket, :new, %{"company_id" => company_id} = _params) do
    # check for company_id = nil

    company = Companies.get_company!(company_id)

    socket
    |> assign(:page_title, "New Department for #{company.name}")
    # |> assign(:department, %Department{company_id: company_id, name: "hello department #{Faker.Company.En.bs()}"})
    |> assign(:department, %Department{name: "hello department #{Faker.Company.En.bs()}"})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Departments")
    |> assign(:department, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    department = Companies.get_department!(id)
    {:ok, _} = Companies.delete_department(department)

    {:noreply, assign(socket, :departments, list_departments())}
  end

  defp list_departments do
    Companies.list_departments()
  end
end
