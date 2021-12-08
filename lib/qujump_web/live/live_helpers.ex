defmodule QujumpWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers
  # import QujumpWeb.QuHelpers

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
  def live_modal(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(QujumpWeb.ModalComponent, modal_opts)
  end

  def employee_name(entity_id) do
    employee = hd Qujump.Employees.get_employee_by_entity_id!(entity_id)
    employee.name
  end

end
