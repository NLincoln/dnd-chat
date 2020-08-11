defmodule DndChatWeb.SessionChatController do
  use DndChatWeb, :controller

  def index(conn, params) do
    player_id = get_session(conn, "player_id")

    render(conn, "show.html", %{
      session_id: params["id"],
      player_id: player_id,
      token: [player_id, params["id"]]
    })
  end
end
