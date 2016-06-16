defmodule VerkWeb.Router do
  use VerkWeb.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VerkWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/queues/:queue", QueuesController, :show
    get "/queues/:queue/busy", QueuesController, :busy
    get "/queues/:queue/jobs/:job_id", JobController, :show
    get "/retries", RetriesController, :index
    delete "/retries", RetriesController, :destroy
    get "/dead", DeadJobsController, :index
    delete "/dead", DeadJobsController, :destroy
  end
end
