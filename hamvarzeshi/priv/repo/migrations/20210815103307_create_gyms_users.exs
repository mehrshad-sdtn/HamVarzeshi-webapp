defmodule Hamvarzeshi.Repo.Migrations.CreateGymsUsers do
  use Ecto.Migration

  def change do
    create table(:gyms_users) do
      add :gym_id, references(:gyms, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:gyms_users, [:gym_id, :user_id])
  end
end
