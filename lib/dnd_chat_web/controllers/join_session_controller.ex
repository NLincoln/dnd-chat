defmodule DndChatWeb.JoinSessionController do
  use DndChatWeb, :controller

  alias DndChat.Sessions

  def show(conn, %{"id" => slug}) do
    {:ok, session} = Sessions.get_by_invite(slug)
    render(conn, "show.html", session: session, slug: slug)
  end

  def join_session(conn, %{"player_name" => player_name, "slug" => slug}) do
    {:ok, session, player} =
      Sessions.join_by_invite(%{
        slug: slug,
        player_name: player_name
      })

    conn
    |> put_session("player_id", player.id)
    |> redirect(to: Routes.session_chat_path(conn, :index, session.id))
  end
end
