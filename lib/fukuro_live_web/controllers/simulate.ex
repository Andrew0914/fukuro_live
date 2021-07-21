defmodule FukuroLiveWeb.Simulate do
  use FukuroLiveWeb, :controller

  def index(conn, params) do
    conn
    |> put_status(200)
    |> json(params)
  end
end
