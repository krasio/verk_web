defmodule VerkWeb.DeadJobsController do
  use VerkWeb.Web, :controller

  require Logger

  def index(conn, params) do
    paginator = VerkWeb.RangePaginator.new(Verk.DeadSet.count!, params["page"], params["per_page"])

    render conn, "index.html",
      dead_jobs: Verk.DeadSet.range!(paginator.from, paginator.to),
      has_next: paginator.has_next,
      has_prev: paginator.has_prev,
      page: paginator.page,
      per_page: paginator.per_page
  end

  def destroy(conn, %{ "jobs_to_remove" => jobs_to_remove }) do
    jobs_to_remove = jobs_to_remove || []

    for job <- jobs_to_remove, do: Verk.DeadSet.delete_job!(job)

    redirect conn, to: dead_jobs_path(conn, :index)
  end

  def destroy(conn, _params) do
    Verk.DeadSet.clear!

    redirect conn, to: dead_jobs_path(conn, :index)
  end
end
