defmodule Hamvarzeshi.Repo.Migrations.CreateGyms do
  use Ecto.Migration

  def change do
    create table(:gyms) do
      add :name, :string
      add :photo, :string
      add :description, :string
      add :rating, :integer

      timestamps()
    end

  end
end
