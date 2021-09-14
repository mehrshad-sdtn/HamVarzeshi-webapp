defmodule Hamvarzeshi.Repo.Migrations.RemoveAdmin do
  use Ecto.Migration

  def change do
    alter table(:gyms) do
      remove :admin
    end

  end
end
