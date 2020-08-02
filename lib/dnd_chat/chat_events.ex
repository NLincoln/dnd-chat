defmodule DndChat.ChatEvents do
  alias DndChat.ChatEvents.{Message, Event}
  alias DndChat.Repo

  def send_message(session_id, message = %Message{}) do
    # Validate that the session exists
    %DndChat.Sessions.Session{} = DndChat.Sessions.get_by_id(session_id)

    event =
      Event.changeset(%Event{}, %{
        session_id: session_id,
        timestamp: DateTime.utc_now(),
        data: %{
          type: "Message",
          player_id: message.player_id,
          text: message.text
        }
      })

    {:ok, _} = Repo.insert(event)
    :ok
  end

  def new_message(player_id) do
    Message.changeset(%Message{}, %{
      player_id: player_id,
      text: ""
    })
  end
end
