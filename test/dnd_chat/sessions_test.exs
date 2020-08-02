defmodule DndChat.SessionsTest do
  use DndChat.DataCase, async: true

  alias DndChat.Sessions

  test "can create invites for new sessions" do
    {:ok, session} = Sessions.new_session(%{name: "Cool session!"})
    {:ok, invite} = Sessions.create_invite(session)
    assert String.length(invite.slug) == 256
    assert invite.session_id == session.id
  end

  test "can get the session for an invite" do
    {:ok, session} = Sessions.new_session(%{name: "Cool session!"})
    {:ok, invite} = Sessions.create_invite(session)
    {:ok, found_session} = Sessions.get_by_invite(invite.slug)
    assert found_session.id == session.id
  end

  test "can join by session slug" do
    {:ok, session} = Sessions.new_session(%{name: "Cool session!"})
    {:ok, invite} = Sessions.create_invite(session)

    {:ok, found_session, player} =
      Sessions.join_by_invite(%{
        slug: invite.slug,
        player_name: "Cool nameee"
      })

    assert player.name == "Cool nameee"
    assert found_session.id == session.id
  end
end
