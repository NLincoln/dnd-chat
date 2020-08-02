defmodule DndChat.ChatEvents.Message do
  use DndChat.Schema

  import Ecto.Changeset

  embedded_schema do
    field :player_id, :binary_id
    field :text, :string
  end

  def changeset(message, attrs \\ %{}) do
    message
    |> cast(attrs, [
      :player_id,
      :text
    ])
  end
end
