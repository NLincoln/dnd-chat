defmodule DndChatWeb.SessionChatLive do
  use DndChatWeb, :live_view

  def mount(params, _session, socket) do
    session = DndChat.Sessions.get_by_id(Map.get(params, "id"))
    {:ok, assign(socket, playsession: session)}
  end
end
