defmodule DndChatWeb.SessionChannel do
  use Phoenix.Channel

  alias DndChat.{Sessions, ChatEvents, PubSub}

  require Logger

  def join("session:" <> session_id, params, socket) do
    PubSub.subscribe_messages(socket.assigns.session_id)
    {:ok, socket}
  end

  def handle_in("get_recent_messages", %{}, socket) do
    push(socket, "recent_messages", %{
      messages: DndChat.ChatEvents.recent(socket.assigns.session_id)
    })

    {:noreply, socket}
  end

  def handle_in("message", %{"text" => message}, socket) do
    case String.trim(message) do
      "" ->
        :ok

      text ->
        player = Sessions.get_player_by_id(socket.assigns.player_id)

        ChatEvents.send_message(socket.assigns.session_id, %DndChat.ChatEvents.Message{
          player_id: socket.assigns.player_id,
          player_name: player.name,
          text: text
        })

        :ok
    end

    {:noreply, socket}
  end

  def handle_info({:new_message, _}, socket) do
    push(socket, "recent_messages", %{
      messages: DndChat.ChatEvents.recent(socket.assigns.session_id)
    })

    {:noreply, socket}
  end
end
