defmodule Qujump.Teams do
  @moduledoc """
  The Organizations context.
  """

  import Ecto.Query, warn: false
  #alias Qujump.Repo
  alias Qujump.Employees
  alias Qujump.Entities
  alias Qujump.Orgstructs

  def list_team_id(team_id) do
    Orgstructs.get_orgstruct_with_members(team_id)
  end

  def list_members_by_team_id(team_id) do
    t = Orgstructs.get_orgstruct_with_members(team_id)
    t.entity.members
  end

  def insert_team_member(team_id, employee_id) do
    employee_entity_id = Employees.get_employee_entity_id!(employee_id)
    team_entity_id = Orgstructs.get_orgstruct_entity_id!(team_id)
    Entities.create_entity_member(%{entity_id: team_entity_id, member_id: employee_entity_id})
  end

end


