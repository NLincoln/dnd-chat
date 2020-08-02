defmodule DndChat.Sessions.SessionInvite do
  use DndChat.Schema

  schema "session_invite" do
    field :session_id, :binary_id
    field :slug, :string
  end
end
