defmodule DndChat.ChatEvents do
  alias DndChat.ChatEvents.{Message, Event}
  alias DndChat.Repo
  alias DndChat.Sessions
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

  defp process_event_data(event = %{"type" => "Message"}) do
    %{
      type: "Message",
      player_id: Map.get(event, "player_id"),
      player_name: Map.get(event, "player_name"),
      text: Map.get(event, "text")
    }
  end

  defp process_event_data(event = %{"type" => "DiceRoll"}) do
    %{
      type: "DiceRoll",
      player_id: Map.get(event, "player_id"),
      player_name: Map.get(event, "player_name"),
      roll: Map.get(event, "roll"),
      result: event["result"]["total"]
    }
  end

  def process_message(_session = %Sessions.Session{}, message = %Message{}) do
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

  def send_message(session_id, message = %Message{}) do
    # Validate that the session exists
    session = %Sessions.Session{} = Sessions.get_by_id(session_id)

    event =
      Event.changeset(%Event{}, %{
        session_id: session_id,
        timestamp: DateTime.utc_now(),
        data: process_message(session, message)
      })

    {:ok, _} = Repo.insert(event)
    DndChat.PubSub.broadcast_message(session_id)
    :ok
  end

  def new_message(player) do
    Message.changeset(%Message{}, %{
      player_id: player.id,
      player_name: player.name,
      text: ""
    })
  end
end
