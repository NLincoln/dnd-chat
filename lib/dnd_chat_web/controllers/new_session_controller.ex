defmodule DndChatWeb.NewSessionController do
  use DndChatWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
