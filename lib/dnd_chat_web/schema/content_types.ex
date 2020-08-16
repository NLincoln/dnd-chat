defmodule DndChatWeb.Schema.ContentTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  alias DndChat.Sessions
  import Ecto.Query, only: [from: 2]

  object :session do
    field :id, non_null(:id)
    field :name, non_null(:string)

    field :players, list_of(non_null(:player)) do
      resolve(fn session, _args, _resolution ->
        players =
          Sessions.players(session.id)
          |> DndChat.Repo.all()

        {:ok, players}
      end)
    end

    field :invite_slug, non_null(:string) do
      resolve(fn session, _args, _resolution ->
        invite =
          from(Sessions.invites(session.id),
            limit: 1
          )
          |> DndChat.Repo.one()

        {:ok, invite.slug}
      end)
    end
  end

  object :player do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :session_id, non_null(:id)

    field :session, non_null(:session) do
      resolve(fn player, _args, _resolution ->
        {:ok, Sessions.get_by_id(player.session_id)}
      end)
    end
  end
end
