defmodule DndChatWeb.ApiToken do
  def sign(conn, player_id, session_id) do
    Phoenix.Token.sign(conn, "session token", [player_id, session_id])
  end

  def verify(socket, token) do
    case Phoenix.Token.verify(socket, "session token", token, max_age: 86400) do
      {:ok, [player_id, session_id]} ->
        {:ok, {player_id, session_id}}

      {:error, _} ->
        :error
    end
  end
end
