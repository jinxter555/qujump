defmodule QujumpWeb.CoreHelper do

  alias QujumpWeb.AuthUser
  #alias Qujump.Entities

  def setup_employee_params(_socket, params) do
    params
    |> Map.new(fn {k, v} -> 
      case k do
        "type" -> {String.to_atom(k), String.to_atom(v)}
        _ -> {String.to_atom(k), v} 
      end
    end)
  end

  def setup_orgstruct_params(socket, params) do
    employee = AuthUser.get_current_employee(socket)
    params
    |> Map.new(fn {k, v} -> 
      case k do
        "type" -> {String.to_atom(k), String.to_atom(v)}
        _ -> {String.to_atom(k), v} 
      end
    end)
    |> Map.put(:employee_id, employee.id)
  end

  def setup_todo_save_params(socket, params) do
    employee = AuthUser.get_current_employee(socket)
    params
    |> Map.new(fn {k, v} -> 
      case k do
        "state" -> {String.to_atom(k), String.to_integer(v)}
        "type" -> {String.to_atom(k), String.to_atom(v)}
        "assignto_entity_id" -> {String.to_atom(k), String.to_integer(v)}
        "assignby_entity_id" -> {String.to_atom(k), String.to_integer(v)}
        "owner_entity_id" -> {String.to_atom(k), String.to_integer(v)}
        _ -> {String.to_atom(k), v}
      end
    end)
    |> Map.put(:owner_entity_id, employee.entity.id)
  end
end
