defmodule DndChatWeb.SessionController do
  use DndChatWeb, :controller

  def show(conn, params) do
    live_render(conn, DndChatWeb.SessionChatLive, session: params)
  end
end
