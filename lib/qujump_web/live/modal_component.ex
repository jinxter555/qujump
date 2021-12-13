defmodule QujumpWeb.ModalComponent do
  use QujumpWeb, :live_component

  @impl true
  def render(assigns) do
    {_, title} = List.keyfind(assigns.opts, :big_title, 0, {:ok, "title"})
    ~H"""
    <div id={@id} class="modal fade phx-modal"
      phx-hook="BsModal"
      phx-target={@myself}
      phx-page-loading>
    
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title"><%= title %></h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <%= live_component @component, @opts %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("close", _params, socket) do
    send_reset(socket)
    try do
      {:noreply, push_patch(socket, to: socket.assigns.return_to) }
    rescue
      _ -> {:noreply, push_redirect(socket, to: socket.assigns.return_to) }
    end
  end

  defp send_reset(socket) do
    #orgstruct_id = opts[:orgstruct_id]
    #IO.inspect socket
    
    opts = socket.assigns.opts
    if opts[:reset_cmp] && opts[:reset_id] do
      reset_id = opts[:reset_id]
      reset_cmp = opts[:reset_cmp]
      #send_update(EmployeeComponent, id: "employee-cmp", orgstruct_id: orgstruct_id)
      #send_update(reset_cmp, id: reset_id, orgstruct_id: orgstruct_id)
      send_update(reset_cmp, id: reset_id)
    end
  end
end
