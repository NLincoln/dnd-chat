defmodule DndChat.Release do
  @app :dnd_chat

  require Logger

  def migrate do
    Logger.info("Running migrations.")

    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Logger.info("Loading application")
    {:ok, _} = Application.ensure_all_started(@app)
  end
end
