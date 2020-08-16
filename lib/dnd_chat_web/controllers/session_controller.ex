defmodule DndChatWeb.SessionController do
  use DndChatWeb, :controller

  alias DndChat.Sessions

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new_session(conn, %{"session_name" => session_name}) do
    {:ok, session} = Sessions.new_session(%{name: session_name})
    {:ok, invite} = Sessions.create_invite(session)

    redirect(conn, to: Routes.session_path(conn, :show_join, invite.slug))
  end

  def show_join(conn, %{"id" => slug}) do
    {:ok, session} = Sessions.get_by_invite(slug)
    render(conn, "show_join.html", session: session, slug: slug, invite_url: current_url(conn))
  end

  def join_session(conn, %{"player_name" => player_name, "slug" => slug}) do
    {:ok, session, player} =
      Sessions.join_by_invite(%{
        slug: slug,
        player_name: player_name
      })

    conn
    |> put_session("player_id", player.id)
    |> redirect(to: Routes.session_path(conn, :chat, session.id))
  end

  def chat(conn, params) do
    player_id = get_session(conn, "player_id")

    render(conn, "chat.html", %{
      session_id: params["id"],
      player_id: player_id,
      token: DndChatWeb.ApiToken.sign(conn, player_id, params["id"])
    })
  end
end
