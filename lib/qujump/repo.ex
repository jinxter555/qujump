defmodule Qujump.Repo do
  use Ecto.Repo,
    otp_app: :qujump,
    adapter: Ecto.Adapters.Postgres
end
