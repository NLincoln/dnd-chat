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

  pipeline :admin do
    plug :auth

    defp verify_creds(user, pass) do
      system = Application.get_env(:dnd_chat, :basic_auth)
      system_username = Keyword.fetch!(system, :username)
      system_password = Keyword.fetch!(system, :password)

      if Plug.Crypto.secure_compare(user, system_username) &&
           Plug.Crypto.secure_compare(pass, system_password) do
        :ok
      else
        :err
      end
    end

    defp auth(conn, _opts) do
      with {user, pass} <- Plug.BasicAuth.parse_basic_auth(conn),
           :ok = verify_creds(user, pass) do
        assign(conn, :admin_username, user)
      else
        _ -> conn |> Plug.BasicAuth.request_basic_auth() |> halt()
      end
    end
  end

  scope "/", DndChatWeb do
    pipe_through :browser

    # live "/", PageLive, :index
    get "/", SessionController, :index
    post "/new-session", SessionController, :new_session

    get "/join-session/:id", SessionController, :show_join
    post "/join-session/:slug/join", SessionController, :join_session

    get "/session/:id", SessionController, :chat
  end

  # Other scopes may use custom stacks.
  scope "/api" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: DndChatWeb.Schema

    forward "/graphql", Absinthe.Plug, schema: DndChatWeb.Schema
  end

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

  if Mix.env() in [:prod] do
    import Phoenix.LiveDashboard.Router

    scope "/admin" do
      pipe_through :browser
      pipe_through :admin
      live_dashboard "/dashboard", metrics: DndChatWeb.Telemetry
    end
  end
end
