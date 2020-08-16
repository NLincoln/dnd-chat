defmodule DndChatWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern

  import_types(DndChatWeb.Schema.ContentTypes)

  query do
    @desc "Get session by ID"
    field :session, non_null(:session) do
      arg(:id, non_null(:id))

      resolve(fn _parent, %{id: id}, _resolution ->
        {:ok, DndChat.Sessions.get_by_id(id)}
      end)
    end
  end
end
