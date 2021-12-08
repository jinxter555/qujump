defmodule QujumpWeb.Router do
  use QujumpWeb, :router

  import QujumpWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {QujumpWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", QujumpWeb, on_mount: AuthUser do
    # pipe_through :browser
    pipe_through [:browser, :require_authenticated_user]

    get "/", PageController, :index


    live "/employees", EmployeeLive.Index, :index        
    live "/employees/:orgstruct_id/new", EmployeeLive.Index, :new
    live "/employees/:orgstruct_id/list", EmployeeLive.Index, :list
    live "/employees/:id/edit", EmployeeLive.Index, :edit  



    live "/companies", CompanyLive.Index, :index
    live "/companies/new", CompanyLive.Index, :new
    live "/companies/:id/edit", CompanyLive.Index, :edit

    live "/companies/:id", CompanyLive.Show, :show
    live "/companies/:id/show/edit", CompanyLive.Show, :edit
    # live "/companies/:id/show/create_department", DepartmentLive.Index, :new


    live "/departments", DepartmentLive.Index, :index
    # live "/departments/new", DepartmentLive.Index, :new
    live "/departments/:company_id/new", DepartmentLive.Index, :new
    live "/departments/:id/edit", DepartmentLive.Index, :edit

    live "/departments/:id", DepartmentLive.Show, :show
    live "/departments/:id/show/edit", DepartmentLive.Show, :edit

    live "/todos", TodoLive.Index, :index
    live "/todos/new", TodoLive.Index, :new
    live "/todos/:id/edit", TodoLive.Index, :edit
    live "/todos/:id", TodoLive.Show, :show
    live "/todos/:id/show/edit", TodoLive.Show, :edit

    live "/orgstructs", OrgstructLive.Index, :index
    live "/orgstructs/new", OrgstructLive.Index, :new
    live "/orgstructs/:id/edit", OrgstructLive.Index, :edit
    live "/orgstructs/:id", OrgstructLive.Show, :show
    live "/orgstructs/:id/show/edit", OrgstructLive.Show, :edit

    live "/orgstructs/:orgstruct_id/todo/:id/edit", OrgstructLive.Show, :edit
    live "/orgstructs/:orgstruct_id/todo/new", OrgstructLive.Show, :edit

    live "/orgstructs/:orgstruct_id/member/:id/edit", OrgstructMemberLive.Index, :edit
    live "/orgstructs/:orgstruct_id/member/new", OrgstructMemberLive.Index, :new


    live "/orgstruct_members/:orgstruct_id", OrgstructMemberLive.Index, :index
    live "/orgstruct_members/:orgstruct_id/new", OrgstructMemberLive.Index, :new
    live "/orgstruct_members/:id/edit", OrgstructMemberLive.Index, :edit
    live "/orgstruct_members/:id/show/edit", OrgstructMemberLive.Show, :edit

    live "/orgmain", OrgmainLive.Index, :index
    live "/orgmain/new", OrgmainLive.Index, :new



  end

  # Other scopes may use custom stacks.
  # scope "/api", QujumpWeb do
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
      live_dashboard "/dashboard", metrics: QujumpWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", QujumpWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", QujumpWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", QujumpWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end
end