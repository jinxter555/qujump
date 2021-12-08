defmodule QujumpWeb.TodoLiveTest do
  use QujumpWeb.ConnCase


  import Phoenix.LiveViewTest
  import Qujump.WorkFixtures
  import Qujump.EmployeeFixtures
  #alias Qujump.Repo
  #
  #
    #@create_attrs %{body: "some body"}
  @create_attrs2 %{description: "Hello Infinite Universe"}
  @update_attrs %{description: "some updated description"}
  @invalid_attrs %{description: nil}



  defp create_todo(_) do
    %{todo: todo_fixture()}
  end

  defp create_employee(_) do
     %{employee: employee_fixture()}
  end


  describe "Index" do
    #setup do
    #  :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    #end

    setup [:create_todo, :create_employee]

    test "lists all todos", 
    %{conn: conn, employee: employee, todo: todo} do
      conn = conn |> log_in_user(employee.user)
      {:ok, _index_live, html} = conn
        |> live(Routes.todo_index_path(conn, :index))
       
      assert html =~ "todo"
      assert html =~ todo.description
      #IO.inspect "html #{html}"
    end

    test "saves new todo",
    %{conn: conn, employee: employee, todo: _todo} do
      conn = conn |> log_in_user(employee.user)
      {:ok, index_live, _html} = 
        live(conn, Routes.todo_index_path(conn, :index))

      index_live 
        |> element("a", "new todo") 
        |> render_click() =~ "new todo"

      assert_patch(index_live, Routes.todo_index_path(conn, :new))

      assert index_live
        |> form("#todo-form", todo: @invalid_attrs)
        |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} = index_live 
        |> form("#todo-form", todo: @create_attrs2)
        |> render_submit()
        |> follow_redirect(conn, Routes.todo_index_path(conn, :index))

      assert html =~ "Todo created successfully"
      assert html =~ "Universe"
    end

    test "updates todo in listing",
    %{conn: conn, employee: employee, todo: todo} do
      conn = conn |> log_in_user(employee.user)

      {:ok, index_live, _html} = 
        live(conn, Routes.todo_index_path(conn, :index))

      assert index_live |> element("#todo-#{todo.id} a", "Edit") |> render_click() =~
        "Edit Todo"

      assert_patch(index_live, Routes.todo_index_path(conn, :edit, todo))
      assert index_live
             |> form("#todo-form", todo: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"
                                             
      {:ok, _, html} =                                
        index_live                                   
        |> form("#todo-form", todo: @update_attrs)
        |> render_submit()                             
        |> follow_redirect(conn, Routes.todo_index_path(conn, :index))
                                                                        
      assert html =~ "Todo updated successfully"                    
      assert html =~ "some updated description"
    end

    test "deletes todo in listing",
    %{conn: conn, employee: employee, todo: todo} do
      conn = conn |> log_in_user(employee.user)
      {:ok, index_live, _html} = live(conn, Routes.todo_index_path(conn, :index))

      assert index_live |> element("#todo-#{todo.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#todo-#{todo.id}")
    end
  end

  describe "Show" do
    setup [:create_todo, :create_employee]

    #@tag :skip
    test "displays todo",
    %{conn: conn, employee: employee, todo: todo} do
      conn = conn |> log_in_user(employee.user)
      {:ok, _show_live, html} = live(conn, Routes.todo_show_path(conn, :show, todo))

      assert html =~ "Show Todo"
      assert html =~ todo.description
    end
  
    #@tag :skip
    test "updates todo within modal", 
    %{conn: conn, employee: employee, todo: todo} do
      conn = conn |> log_in_user(employee.user)
      {:ok, show_live, _html} = live(conn, Routes.todo_show_path(conn, :show, todo))


      #IO.inspect "html #{html}"

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Todo"

      assert_patch(show_live, Routes.todo_show_path(conn, :edit, todo))

      assert show_live
             |> form("#todo-form", todo: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#todo-form", todo: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.todo_show_path(conn, :show, todo))

      assert html =~ "Todo updated successfully"
      assert html =~ "some updated description"
    end
  end
end

