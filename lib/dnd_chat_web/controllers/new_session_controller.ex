defmodule DndChatWeb.NewSessionController do
  use DndChatWeb, :controller

  alias DndChat.Sessions

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new_session(conn, %{"session_name" => session_name}) do
    {:ok, session} = Sessions.new_session(%{name: session_name})
    {:ok, invite} = Sessions.create_invite(session)

    redirect(conn, to: Routes.join_session_path(conn, :show, invite.slug))
  end
end
