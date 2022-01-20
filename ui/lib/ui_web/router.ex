defmodule UiWeb.Router do
  use UiWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {UiWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", UiWeb do
    pipe_through :browser
    live "/lightscontroller", Lights

    live "/buttons", ButtonLive.Index, :index
    live "/buttons/new", ButtonLive.Index, :new
    live "/buttons/:id/edit", ButtonLive.Index, :edit

    live "/buttons/:id", ButtonLive.Show, :show
    live "/buttons/:id/show/edit", ButtonLive.Show, :edit

    live "/lights", LightLive.Index, :index
    live "/lights/new", LightLive.Index, :new
    live "/lights/:id/edit", LightLive.Index, :edit

    live "/lights/:id", LightLive.Show, :show
    live "/lights/:id/show/edit", LightLive.Show, :edit

    live "/colours", ColourLive.Index, :index
    live "/colours/new", ColourLive.Index, :new
    live "/colours/:id/edit", ColourLive.Index, :edit

    live "/colours/:id", ColourLive.Show, :show
    live "/colours/:id/show/edit", ColourLive.Show, :edit

    live_dashboard "/dashboard"
    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", UiWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  # if Mix.env() in [:dev, :test] do
  # import Phoenix.LiveDashboard.Router

  #    scope "/" do
  #     pipe_through :browser
  #    live_dashboard "/dashboard", metrics: UiWeb.Telemetry
  # end
  # end
end
