defmodule Qujump.Factory do

  # without Ecto
  use ExMachina.Ecto, repo: Qujump.Repo

  alias Qujump.Entities.Entity
  alias Qujump.Entities.EntityMember
  alias Qujump.Accounts.User
  alias Qujump.Organizations.Employee
  alias Qujump.Organizations.Orgstruct

  def user_factory do
    email = sequence(:email, &"email-#{&1}@example.com")

    %User{
      email: email,
      password: "12345678",
      hashed_password: "12345678",
      # password_confirmation: "12345678"
    }
  end

  def entity_factory do
    %Entity {
    }
  end

  def entity_member_factory do
    %EntityMember {
    }
  end

  def orgstruct_factory do
    %Orgstruct {
      name: Faker.Company.name(),
      type: :company,
      entity: build(:entity, %{type: :org}),
    }
  end

  def company_factory do
    %Orgstruct {
      name: Faker.Company.name(),
      type: :company,
      entity: build(:entity, %{type: :org}),
    }
  end

  def department_factory do
    %Orgstruct {
      name: Faker.Company.name(),
      type: :department,
      entity: build(:entity, %{type: :org}),
    }
  end

  def team_factory do
    %Orgstruct {
      name: Faker.Company.name(),
      type: :team,
      entity: build(:entity, %{type: :org}),
    }
  end


  def employee_factory do
    # name = sequence(:name, &"email-#{&1}@example.com")         
    %Employee {
      name: Faker.Person.name(),
      user: build(:user),
      entity: build(:entity, %{type: :employee}),
    }
  end
end
