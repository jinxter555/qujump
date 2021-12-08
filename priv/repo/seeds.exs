# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Qujump.Repo.insert!(%Qujump.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
alias Qujump.Accounts
alias Qujump.Employees
alias Qujump.Orgstructs

{:ok, u} = Accounts.register_user(%{
  email: "jt@example.com",
  password: "12345678",
  password_confirmation: "12345678"
})

{:ok, u1} = Accounts.register_user(%{
  email: "jt1@example.com",
  password: "12345678",
  password_confirmation: "12345678"
})
{:ok, u2} = Accounts.register_user(%{
  email: "jt2@example.com",
  password: "12345678",
  password_confirmation: "12345678"
})

{:ok, e0} = Employees.create_account(%{user_id: u.id})
{:ok, e1} = Employees.create_account(%{user_id: u1.id})
{:ok, e2} = Employees.create_account(%{user_id: u2.id})

{:ok, c1} = Orgstructs.create_orgstruct(%{
  employee_id: e1.id,
  name: "company 1",
  type: :company
})
{:ok, c2} = Orgstructs.create_orgstruct(%{employee_id: e2.id, name: "company 2", type: :company})

{:ok, c0} = Orgstructs.create_orgstruct(%{employee_id: e0.id, name: "company Alpha", type: :company})

{:ok, t1} = Orgstructs.create_orgstruct(%{employee_id: e0.id, name: "team 1", type: :team}, c1.entity_id)

Qujump.Work.create_todo(%{
  owner_entity_id: e0.id,
  description: "walk dog",
  orgstruct_id: c1.id,
  type: :task})

Qujump.Work.create_todo(%{owner_entity_id: e1.id,
  description: "make coffee",
  orgstruct_id: c2.id,
  type: :task})

Qujump.Work.create_todo(%{owner_entity_id: e2.id,
  description: "make bread",
  orgstruct_id: c0.id,
  type: :task})


import Qujump.Factory
employees1 = insert_list(10, :employee, %{orgstruct_id: c1.id})
employees2 = insert_list(10, :employee, %{orgstruct_id: c2.id})
employeesT = insert_list(10, :employee, %{orgstruct_id: c1.id})

for employee <- employeesT do
  Orgstructs.insert_orgstruct_member(t1.id, employee.id)
end


