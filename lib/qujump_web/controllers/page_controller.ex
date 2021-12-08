defmodule QujumpWeb.PageController do
  use QujumpWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
