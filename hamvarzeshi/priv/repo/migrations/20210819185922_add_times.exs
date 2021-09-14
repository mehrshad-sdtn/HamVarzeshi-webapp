defmodule Hamvarzeshi.Repo.Migrations.AddTimes do
  use Ecto.Migration


  def change do
    alter table(:gyms_users) do
      add :start, :time
      add :end, :time
    end
  end
end
