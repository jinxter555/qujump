defmodule QujumpWeb.AuthUser do
  import Phoenix.LiveView

  alias Qujump.Accounts

  
  def on_mount(_, _params, session,  socket) do
    {:cont, assign_new(socket, :current_user, fn -> 
          Accounts.get_user_by_session_token(session["user_token"])
    end)}
  end

  # Ensures common `assigns` are applied to all LiveViews
  # that attach this module as an `on_mount` hook
  def mount(_params, session, socket) do
    {:cont, assign_new(socket, :current_user, fn -> 
          Accounts.get_user_by_session_token(session["user_token"])
    end)}
  end

  def get_current_employee(socket) do

    user = Qujump.Accounts.get_user!(socket.assigns.current_user.id)
    |> Qujump.Repo.preload([employees: [:entity]])
    case user.employees do
      [] ->  nil
      _ -> hd(user.employees)
    end
  end
end
