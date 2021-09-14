defmodule Hamvarzeshi.Repo.Migrations.AddPrice do
  use Ecto.Migration

  def change do
    alter table(:gyms) do
      add :price, :string
    end
  end
end
