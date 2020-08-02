defmodule DndChat.PubSub do
  defp subscribe(topic) do
    Phoenix.PubSub.subscribe(__MODULE__, topic)
  end

  defp broadcast(topic, message) do
    Phoenix.PubSub.broadcast(__MODULE__, topic, message)
  end

  def subscribe_messages(session_id) do
    subscribe("messages:#{session_id}")
  end

  def broadcast_message(session_id) do
    broadcast("messages:#{session_id}", {:new_message, session_id})
  end
end
