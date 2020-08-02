defmodule DndChat.Sessions.Session do
  use DndChat.Schema
  import Ecto.Changeset

  schema "session" do
    field :name, :string
  end

  def changeset(session, params \\ %{}) do
    session
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
