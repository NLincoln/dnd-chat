defmodule DndChatWeb.SessionChatLive do
  use DndChatWeb, :live_view

  alias DndChat.{Sessions, ChatEvents}

  def mount(params, _session, socket) do
    session = Sessions.get_by_id(Map.get(params, "id"))
    message = ChatEvents.new_message("todo")
    {:ok, assign(socket, playsession: session, current_message: message)}
  end

  def handle_event("send_message", %{"message" => message}, socket) do
    ChatEvents.send_message(socket.assigns.playsession.id, %DndChat.ChatEvents.Message{
      player_id: "todo",
      text: Map.get(message, "text")
    })

    {:noreply, socket}
  end
end
