defmodule Qujump.EntitiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Qujump.Entities` context.
  """

  @doc """
  Generate a entity.
  """
  def entity_fixture(attrs \\ %{}) do
    {:ok, entity} =
      attrs
      |> Enum.into(%{
        parent_id: 42,
        type: 100
      })
      |> Qujump.Entities.create_entity()

    entity
  end

  @doc """
  Generate a entity_member.
  """
  def entity_member_fixture(attrs \\ %{}) do
    {:ok, entity_member} =
      attrs
      |> Enum.into(%{
        entity_id: 42,
        member_id: 42
      })
      |> Qujump.Entities.create_entity_member()

    entity_member
  end
end
