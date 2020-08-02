defmodule DndChat.ChatEvents.Event do
  use DndChat.Schema
  import Ecto.Changeset

  schema "event" do
    field :session_id, :binary_id
    field :data, :map
    field :timestamp, :utc_datetime
  end

  def changeset(event, params \\ %{}) do
    event
    |> cast(params, [:session_id, :data, :timestamp])
    |> validate_required([:session_id, :data, :timestamp])
  end
end
