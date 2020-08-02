defmodule DndChat.ChatEvents.Message do
  use DndChat.Schema

  import Ecto.Changeset

  embedded_schema do
    field :player_id, :binary_id
    field :player_name, :string
    field :text, :string
  end

  def changeset(message, attrs \\ %{}) do
    message
    |> cast(attrs, [
      :player_id,
      :player_name,
      :text
    ])
  end
end
