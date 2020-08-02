defmodule DndChat.Sessions do
  alias DndChat.Sessions.Session
  alias DndChat.Repo

  def new_session(%{name: _} = params) do
    session = Session.changeset(%Session{}, params)

    {:ok, session} = Repo.insert(session)
    get_by_id(session.id)
  end

  @spec get_by_id(binary()) :: Session.t()
  def get_by_id(id) do
    Repo.get!(Session, id)
  end
end
