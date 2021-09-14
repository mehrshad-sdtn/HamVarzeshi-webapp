defmodule Hamvarzeshi.Repo.Migrations.AddAdminToGym do
  use Ecto.Migration

  def change do
    alter table(:gyms) do
      add :user_id, references(:users)
    end

  end
end
