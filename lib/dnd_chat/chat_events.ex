defmodule DndChat.ChatEvents do
  alias DndChat.ChatEvents.{Message, Event}
  alias DndChat.Repo
  import Ecto.Query

  defmodule PlayerJoinedEvent do
    defstruct [:player_id, :player_name]
  end

  def events_in_session(session_id) do
    from e in Event,
      where: e.session_id == ^session_id,
      order_by: [desc: e.timestamp]
  end

  def recent_events(query, num_recent \\ 25) do
    from query, limit: ^num_recent
  end

  def build_event_data(message = %Message{}) do
    if String.starts_with?(message.text, "#") do
      %{
        type: "DiceRoll",
        player_id: message.player_id,
        player_name: message.player_name,
        roll: message.text,
        result: DndChat.DiceRoller.execute_roll!(String.trim_leading(message.text, "#"))
      }
    else
      %{
        type: "Message",
        player_id: message.player_id,
        player_name: message.player_name,
        text: message.text
      }
    end
  end

  defp now() do
    DateTime.utc_now() |> DateTime.truncate(:second)
  end

  def build_event(session_id, message = %Message{}) do
    %Event{
      session_id: session_id,
      timestamp: now(),
      data: build_event_data(message)
    }
  end

  def build_event(session_id, event = %PlayerJoinedEvent{}) do
    %Event{
      session_id: session_id,
      timestamp: now(),
      data: %{
        type: "PlayerJoined",
        player_id: event.player_id,
        player_name: event.player_name
      }
    }
  end

  def send_message(session_id, message = %Message{}) do
    persist_event(build_event(session_id, message))
  end

  def persist_event(event = %Event{}) do
    with {:ok, _} <- Repo.insert(event),
         DndChat.PubSub.broadcast_message(event.session_id) do
      :ok
    end
  end

  def new_message(player) do
    Message.changeset(%Message{}, %{
      player_id: player.id,
      player_name: player.name,
      text: ""
    })
  end
end
