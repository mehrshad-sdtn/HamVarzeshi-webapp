defmodule Hamvarzeshi.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :string
      add :user_id, references(:users)
      add :gym_id, references(:gyms)

      timestamps()
    end

  end
end
