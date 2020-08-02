defmodule DndChatWeb.NewSessionController do
  use DndChatWeb, :controller

  alias DndChat.Sessions

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new_session(conn, %{"session_name" => session_name}) do
    session = Sessions.new_session(%{name: session_name})

    redirect(conn, to: Routes.session_chat_path(conn, :index, session.id))
  end
end
