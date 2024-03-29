defmodule OrgstructComponent do
  use QujumpWeb, :live_component

  # alias Qujump.Orgstructs

  defp orgstruct_link(assigns) do
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
        <button phx-click="list_orgstruct_members" phx-value-id={orgstruct.id}>
          Team
        </button>
    """
      :department ->
    ~H"""
        <button phx-click="list_orgstruct_members" phx-value-id={orgstruct.id}>
          dep
        </button>
    """
    end
  end

end
