defmodule DndChatWeb.Router do
  use DndChatWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {DndChatWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug Plug.Session,
      store: :cookie,
      key: "_dndchat_session",
      signing_salt: "0E3kr1v5DwOebyeXAJFec27o"
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DndChatWeb do
    pipe_through :browser

    # live "/", PageLive, :index
    get "/", NewSessionController, :index
    post "/new-session", NewSessionController, :new_session

    live "/session/:id", SessionChatLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", DndChatWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: DndChatWeb.Telemetry
    end
  end
end
