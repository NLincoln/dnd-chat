defmodule DndChatWeb.SessionChatLive do
  use DndChatWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
