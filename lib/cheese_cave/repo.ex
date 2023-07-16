defmodule CheeseCave.Repo do
  use Ecto.Repo,
    otp_app: :cheese_cave,
    adapter: Ecto.Adapters.Postgres
end
