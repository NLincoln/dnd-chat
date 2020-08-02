defmodule DndChat.Sessions do
  alias DndChat.Sessions.{Session, SessionInvite}
  alias DndChat.Repo

  import Ecto.Query, only: [from: 2]

  @invite_slug_length 256

  @spec new_session(%{:name => binary()}) :: {:ok, Session.t()}
  def new_session(%{name: _} = params) do
    session = Session.changeset(%Session{}, params)

    {:ok, session} = Repo.insert(session)
    {:ok, get_by_id(session.id)}
  end

  @spec create_invite(DndChat.Sessions.Session.t()) :: {:ok, DndChat.Sessions.SessionInvite.t()}
  def create_invite(session = %Session{}) do
    invite = %SessionInvite{
      session_id: session.id,
      slug:
        :crypto.strong_rand_bytes(@invite_slug_length)
        |> Base.url_encode64()
        |> binary_part(0, @invite_slug_length)
    }

    {:ok, invite} = Repo.insert(invite)

    {:ok, invite}
  end

  @spec get_by_id(binary()) :: Session.t()
  def get_by_id(id) do
    Repo.get!(Session, id)
  end

  @spec get_by_invite(binary()) :: {:ok, Session.t()}
  def get_by_invite(slug) do
    invite = from(i in SessionInvite, where: i.slug == ^slug) |> Repo.one()
    {:ok, get_by_id(invite.session_id)}
  end
end
