defmodule DndChat.Sessions.Session do
  use DndChat.Schema
  import Ecto.Changeset

  schema "session" do
    field :name, :string
    field :url_slug, :string
  end

  def changeset(session, params \\ %{}) do
    session
    |> cast(params, [:name, :url_slug])
    |> validate_required([:name, :url_slug])
  end
end
