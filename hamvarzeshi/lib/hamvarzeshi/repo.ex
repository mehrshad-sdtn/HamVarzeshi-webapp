defmodule Hamvarzeshi.Repo do
  use Ecto.Repo,
    otp_app: :hamvarzeshi,
    adapter: Ecto.Adapters.Postgres
end
