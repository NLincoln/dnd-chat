defmodule DndChat.Sessions do
  alias DndChat.Sessions.{Session, SessionInvite, Player}
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

  def players(session_id) do
    from p in Player,
      where: p.session_id == ^session_id,
      order_by: p.name
  end

  @spec get_by_id(binary()) :: Session.t()
  def get_by_id(id) do
    Repo.get!(Session, id)
  end

  def get_for_player_id(player_id) do
    player = get_player_by_id(player_id)
    session = get_by_id(player.session_id)
    {:ok, session, player}
  end

  def get_player_by_id(player_id) do
    Repo.get!(Player, player_id)
  end

  @spec get_by_invite(binary()) :: {:ok, Session.t()}
  def get_by_invite(slug) do
    invite = from(i in SessionInvite, where: i.slug == ^slug) |> Repo.one()
    {:ok, get_by_id(invite.session_id)}
  end

  def join_by_invite(%{player_name: player_name, slug: slug}) do
    {:ok, session} = get_by_invite(slug)

    {:ok, player} =
      %Player{
        session_id: session.id,
        name: player_name
      }
      |> Repo.insert()

    :ok =
      DndChat.ChatEvents.build_event(session.id, %DndChat.ChatEvents.PlayerJoinedEvent{
        player_id: player.id,
        player_name: player_name
      })
      |> DndChat.ChatEvents.persist_event()

    {:ok, session, player}
  end
end
