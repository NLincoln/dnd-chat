defmodule DndChat.ChatEvents do
  alias DndChat.ChatEvents.{Message, Event}
  alias DndChat.Repo
  import Ecto.Query

  def recent(session_id) do
    query =
      from e in Event,
        where: e.session_id == ^session_id,
        order_by: [desc: e.timestamp],
        limit: 25

    Repo.all(query) |> Enum.map(fn event -> process_event(event) end)
  end

  defp process_event(event = %Event{}) do
    %{
      id: event.id,
      session_id: event.session_id,
      timestamp: event.timestamp,
      data: process_event_data(event.data)
    }
  end

  defp process_event_data(%{"type" => "Message", "player_id" => player_id, "text" => text}) do
    %{
      type: "Message",
      player_id: player_id,
      text: text
    }
  end

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
    DndChat.PubSub.broadcast_message(session_id)
    :ok
  end

  def new_message(player_id) do
    Message.changeset(%Message{}, %{
      player_id: player_id,
      text: ""
    })
  end
end
