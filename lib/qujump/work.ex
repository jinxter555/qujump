defmodule Qujump.Work do
  @moduledoc """
  The Work context.  Todo and Resources
  """

  import Ecto.Query, warn: false
  alias Qujump.Repo

  alias Qujump.Work.Todo
  alias Qujump.Entities


  @doc """
  Returns the list of todos.

  ## Examples

      iex> list_todos()
      [%Todo{}, ...]

  """
  def list_todos do
    Repo.all(Todo) # |> Repo.preload([:assignto_entity])
  end

  @doc """
  Gets a single todo.

  Raises `Ecto.NoResultsError` if the Todo does not exist.

  ## Examples

      iex> get_todo!(123)
      %Todo{}

      iex> get_todo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_todo!(id), do: Repo.get!(Todo, id)

  @doc """
  Creates a todo.

  ## Examples
  # create_todo(%{owner_entity_id: owner_entity_id, description: String.t(), type: [:task|:list|:project], ...}) 

      iex> create_todo(%{field: value})
      {:ok, %Todo{}}

      iex> create_todo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_todo(%{owner_entity_id: integer, description: String.t(), type: atom()}) :: {atom(), %Todo{}}
  def create_todo(%{owner_entity_id: owner_entity_id, description: description, type: type} = attrs) do
    Repo.transaction(fn ->
      owner_entity = Entities.get_entity!(owner_entity_id)
      {:ok, entity} = Entities.create_entity(%{type: :todo})
      
      todo = Map.merge(%Todo{type: type, description: description}, attrs)
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_assoc(:entity, entity)
      |> Ecto.Changeset.put_assoc(:owner_entity, owner_entity)
      |> Repo.insert!()
      todo
    end)
  end

  @doc """
  Updates a todo.

  ## Examples

      iex> update_todo(todo, %{field: new_value})
      {:ok, %Todo{}}

      iex> update_todo(todo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @entity_key_names  [
    :assignto_entity_id, 
    :assignby_entity_id,
    :owner_entity_id,
  ]
  def update_todo(%Todo{} = todo, attrs) do
    {:ok, todo} = Repo.transaction(fn ->
      Enum.each(@entity_key_names, fn k ->
        if Map.has_key?(attrs, k) do
          update_todo_entity_id(todo.id, 
            {k, Map.fetch!(attrs, k)})
        end
      end)
      todo
      |> Todo.changeset(attrs)
      |> Repo.update()
    end)
    todo
  end

  @doc """
  Updates a todo owner|assignto|assignby entity id.

  ## Examples

      iex> update_todo_entity_id(1, %{assignto_entity_id: 10})
      {:ok, %Todo{}}


  """
  def update_todo_entity_id(id, attr) do
    try do
      from(t in Todo, where: t.id == ^id) 
      |> Repo.update_all( set: [attr])
      |> case do
        {1, nil} ->
          {:ok, get_todo!(id)}
        _ ->
          {:error, "update todo return error"}
      end
    rescue 
      e -> {:error, e}
    end
  end

  @doc """
  Deletes a todo.

  ## Examples

      iex> delete_todo(todo)
      {:ok, %Todo{}}

      iex> delete_todo(todo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_todo(%Todo{} = todo) do
    Repo.delete(todo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo changes.

  ## Examples

      iex> change_todo(todo)
      %Ecto.Changeset{data: %Todo{}}

  """
  def change_todo(%Todo{} = todo, attrs \\ %{}) do
    Todo.changeset(todo, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo changes.

  ## Examples

      iex> get_employees(todo)
      %Ecto.Changeset{data: %Todo{}}
  """
  alias Qujump.Organizations.Employee
  def get_employees(%Todo{} = _todo, _attrs \\ %{}) do
    # should just get list of employees from owner company
    Repo.all(Employee) |> Repo.preload([:entity])
  end
end
