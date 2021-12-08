defmodule QujumpWeb.QuHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `QujumpWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal QujumpWeb.CompanyLive.FormComponent,
        id: @company.id || :new,
        action: @live_action,
        company: @company,
        return_to: Routes.company_index_path(@socket, :index) %>
  """
  def employee_name(entity_id) do
    employee = hd Qujump.Employees.get_employee_by_entity_id!(entity_id)
    employee.name
  end

  def orgstruct_link(assigns) do
    orgstruct = assigns.orgstruct
    case orgstruct.type do
      type when type in [:company, :corporate_group] ->
    ~H"""
       <button phx-click="list_employees" phx-value-id={orgstruct.id}>
          Employees
       </button>
    """
      :team ->
    ~H"""
        <button phx-click="list_employees" phx-value-id={orgstruct.id}>
          Team
        </button>
    """
    end
  end

end
