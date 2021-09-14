defmodule Hamvarzeshi.Repo.Migrations.AddRatedCount do
  use Ecto.Migration

  def change do
    alter table(:gyms) do
      add :count_rated, :integer
    end

  end
end
