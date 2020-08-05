defmodule DndChatWeb.SessionChatLive do
  use DndChatWeb, :live_view

  alias DndChat.{Sessions, ChatEvents}

  def mount(params, session, socket) do
    {:ok, playsession, player} = Sessions.get_for_player_id(Map.get(session, "player_id"))
    DndChat.PubSub.subscribe_messages(playsession.id)
    message = ChatEvents.new_message(player)
    events = ChatEvents.recent(playsession.id)

    {:ok,
     assign(socket,
       playsession: playsession,
       current_message: message,
       events: events,
       player: player
     )}
  end

  def handle_event("send_message", %{"message" => message}, socket) do
    case String.trim(Map.get(message, "text")) do
      "" ->
        {:noreply, socket}

      text ->
        ChatEvents.send_message(socket.assigns.playsession.id, %DndChat.ChatEvents.Message{
          player_id: socket.assigns.player.id,
          player_name: socket.assigns.player.name,
          text: text
        })

        {:noreply,
         assign(socket, :current_message, ChatEvents.new_message(socket.assigns.player))}
    end
  end

  def handle_info({:new_message, _}, socket) do
    {:noreply, assign(socket, events: ChatEvents.recent(socket.assigns.playsession.id))}
  end
end
