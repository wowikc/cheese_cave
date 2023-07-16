defmodule CheeseCaveWeb.Router do
  use CheeseCaveWeb, :router

  import CheeseCaveWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CheeseCaveWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CheeseCaveWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", CheeseCaveWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:cheese_cave, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: CheeseCaveWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", CheeseCaveWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{CheeseCaveWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", Live.User.UserRegistrationLive, :new
      live "/users/log_in", Live.User.UserLoginLive, :new
      live "/users/reset_password", Live.User.UserForgotPasswordLive, :new
      live "/users/reset_password/:token", Live.User.UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", CheeseCaveWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{CheeseCaveWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", Live.User.UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", Live.User.UserSettingsLive, :confirm_email

      live "/cheeses", CheeseLive.Index, :index
      live "/cheeses/new", CheeseLive.Index, :new
      live "/cheeses/:id/edit", CheeseLive.Index, :edit

      live "/cheeses/:id", CheeseLive.Show, :show
      live "/cheeses/:id/show/edit", CheeseLive.Show, :edit
    end
  end

  scope "/", CheeseCaveWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{CheeseCaveWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", Live.User.UserConfirmationLive, :edit
      live "/users/confirm", Live.User.UserConfirmationInstructionsLive, :new
    end
  end
end
