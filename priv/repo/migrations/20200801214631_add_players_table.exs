defmodule DndChat.Repo.Migrations.AddPlayersTable do
  use Ecto.Migration

  def change do
    create table(:session) do
      add :name, :string, null: false
      add :url_slug, :string, null: false
    end

    create table(:session_invite) do
      add :session_id, references(:session), null: false
      add :slug, :string, size: 256, null: false
    end

    create table(:player) do
      add :session_id, references(:session), null: false
      add :name, :string, null: false

      timestamps
    end

    create table(:event) do
      add :session_id, references(:session), null: false
      add :data, :json, null: false
      add :timestamp, :utc_datetime, null: false
    end

    create index("player", [:session_id], name: :player_session_id_idx)

    create index("event", [:session_id, "timestamp DESC NULLS LAST"],
             name: :event_session_timestamp_idx
           )
  end
end
