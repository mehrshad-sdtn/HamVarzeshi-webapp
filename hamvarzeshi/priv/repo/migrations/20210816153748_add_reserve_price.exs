defmodule Hamvarzeshi.Repo.Migrations.AddReservePrice do
  use Ecto.Migration

  def change do
    alter table(:gyms_users) do
      add :price, :string
    end
  end
end
