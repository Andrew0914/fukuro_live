defmodule FukuroLiveWeb.Simulate do
  use FukuroLiveWeb, :controller
  @topic "notifications"

  def index(conn, params) do
    FukuroLiveWeb.Endpoint.broadcast(@topic, "event", params)
    conn
    |> put_status(200)
    |> json(params)
  end

end
