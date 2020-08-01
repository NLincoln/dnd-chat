defmodule DndChat.Repo do
  use Ecto.Repo,
    otp_app: :dnd_chat,
    adapter: Ecto.Adapters.Postgres
end
