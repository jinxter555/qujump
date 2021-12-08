defmodule QujumpWeb.CompanyLive.Index do
  use QujumpWeb, :live_view

  alias Qujump.Companies
  alias Qujump.Organizations.Orgstruct, as: Company
  # alias Qujump.Accounts

  on_mount QujumpWeb.AuthUser

  @impl true
  def mount(_params, _session, socket) do
    {:ok, 
      socket
      |> assign(:companies, list_companies())
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Index Edit Company")
    |> assign(:company, Companies.get_company!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Company")
    |> assign(:company, %Company{type: :company})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Companies")
    |> assign(:company, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    company = Companies.get_company!(id)
    {:ok, _} = Companies.delete_company(company)

    {:noreply, assign(socket, :companies, list_companies())}
  end

  defp list_companies do
    Companies.list_companies()
  end
end
