defmodule FukuroLive.Repo do
  use Ecto.Repo,
    otp_app: :fukuro_live,
    adapter: Ecto.Adapters.Postgres
end
