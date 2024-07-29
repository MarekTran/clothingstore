defmodule Clothingstore.Repo do
  use Ecto.Repo,
    otp_app: :clothingstore,
    adapter: Ecto.Adapters.Postgres
end
