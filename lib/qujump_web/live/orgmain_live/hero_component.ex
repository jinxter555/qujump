defmodule HeroComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  use Phoenix.LiveComponent

  def handle_event("say_hero", params, socket) do
    IO.puts "what is goingon "
    IO.inspect params
     {:noreply, socket}
  end

end
