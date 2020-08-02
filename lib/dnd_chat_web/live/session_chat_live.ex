defmodule DndChatWeb.SessionChatLive do
  use DndChatWeb, :live_view

  alias DndChat.{Sessions, ChatEvents}

  def mount(params, _session, socket) do
    session = Sessions.get_by_id(Map.get(params, "id"))
    DndChat.PubSub.subscribe_messages(session.id)
    message = ChatEvents.new_message("todo")
    events = ChatEvents.recent(session.id)
    {:ok, assign(socket, playsession: session, current_message: message, events: events)}
  end

  def handle_event("send_message", %{"message" => message}, socket) do
    ChatEvents.send_message(socket.assigns.playsession.id, %DndChat.ChatEvents.Message{
      player_id: "todo",
      text: Map.get(message, "text")
    })

    {:noreply, socket}
  end

  def handle_info({:new_message, _}, socket) do
    {:noreply, assign(socket, events: ChatEvents.recent(socket.assigns.playsession.id))}
  end
end
