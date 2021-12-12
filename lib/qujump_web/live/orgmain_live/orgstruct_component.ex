defmodule OrgstructComponent do
  use QujumpWeb, :live_component

  alias Qujump.Orgstructs

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

  
  @mytabspace "    "
  def list_nested_orgstruct(orgstruct_id) do
    descents = Orgstructs.list_descendants(orgstruct_id)
    build_nested_orgstruct(descents, nil, 0)
  end

  def build_nested_orgstruct([], _, _), do: ""

  def build_nested_orgstruct([head|tail], nil, count) do
    divstr(head.name) <> build_nested_orgstruct(tail, head.entity_id, count + 1)
  end

  def build_nested_orgstruct([_head| tail] = l, parent_id, count) do
    str = String.duplicate(@mytabspace, count)
    Enum.reduce(l, "", fn x, acc -> 
      # am I a child of the calling function 
      if x.entity.parent_id == parent_id do # 
        acc <> str <> divstr(x.name) <>
        build_nested_orgstruct(tail, x.entity_id, count + 1) 
      else
        acc
      end
    end) 
  end

  defp divstr(str) do
    "<div> #{str} </div>\n"
  end

end
