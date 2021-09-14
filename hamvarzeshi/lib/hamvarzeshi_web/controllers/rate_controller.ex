defmodule HamvarzeshiWeb.RateController do
  use HamvarzeshiWeb, :controller
  alias Hamvarzeshi.Gym
  alias Hamvarzeshi.Repo
  import Ecto

  def rate(conn, %{"for" => rate, "id" => gym_id} = params) do
    num = String.to_integer(rate)
    old_data = Repo.get!(Gym, gym_id)
    changeset = build_changeset(old_data, num)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "gym records updated")
        |> redirect(to: Routes.user_path(conn, :index, conn.assigns.user.id))

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.page_path(conn, :index))
    end

  end

  def get_form(conn, %{"id" => gym_id, "name" => gym_name} = params) do

    render(conn, "rate-page.html", gym_id: gym_id, gym_name: gym_name)
  end


  def build_changeset(old_data, num) do
    if old_data.rating do
      new_count = old_data.count_rated + 1
      sum_rate = num + old_data.rating
      Gym.changeset(old_data, %{"rating" => sum_rate , "count_rated" => new_count})
    else
      Gym.changeset(old_data, %{"rating" => num, "count_rated" => 1})
    end
  end

end
