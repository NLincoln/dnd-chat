defmodule DndChat.ChatEvents do
  alias DndChat.ChatEvents.{Message, Event}
  alias DndChat.Repo
  alias DndChat.Sessions
  import Ecto.Query

  def events_in_session(session_id) do
    from e in Event,
      where: e.session_id == ^session_id,
      order_by: [desc: e.timestamp]
  end

  def recent_events(query, num_recent \\ 25) do
    from query, limit: ^num_recent
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
