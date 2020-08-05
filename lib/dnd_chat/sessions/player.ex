defmodule DndChat.Sessions.Player do
  use DndChat.Schema

  schema "player" do
    field :session_id, :binary_id
    field :name, :string

    timestamps()
  end
end
