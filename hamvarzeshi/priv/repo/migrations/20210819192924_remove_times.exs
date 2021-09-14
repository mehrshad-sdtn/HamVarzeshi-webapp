defmodule Hamvarzeshi.Repo.Migrations.RemoveTimes do
  use Ecto.Migration
  def change do
    alter table(:gyms_users) do
      remove :start, :time
      remove :end, :time
    end
  end
end
