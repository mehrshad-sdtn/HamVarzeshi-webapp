defmodule HamvarzeshiWeb.Router do
  use HamvarzeshiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Hamvarzeshi.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HamvarzeshiWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/:id", UserController, :index
    get "/detail/:user_id/:gym_id", UserController, :show_detail


  end

  scope "/gym", HamvarzeshiWeb do
    pipe_through :browser

    get "/new", GymController, :new
    post "/", GymController, :create
    get "/:id", GymController, :show
    get "/:id/edit", GymController, :edit
    put "/:id", GymController, :update
    delete "/:id", GymController, :delete
  end

  scope "/auth", HamvarzeshiWeb do
    pipe_through :browser
    get "/signout", AuthController, :sign_out
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/reserve", HamvarzeshiWeb do
    pipe_through :browser
    get "/:id/times", ReserveController, :reserve_times
    post "/:id", ReserveController, :reserve
    get "/cancel/:id", ReserveController, :cancel
  end

  scope "/rate", HamvarzeshiWeb do
    pipe_through :browser
    get "/:id/:name", RateController, :get_form
    post "/:id", RateController, :rate
  end


  # Other scopes may use custom stacks.
  # scope "/api", HamvarzeshiWeb do
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
      live_dashboard "/dashboard", metrics: HamvarzeshiWeb.Telemetry
    end
  end
end
