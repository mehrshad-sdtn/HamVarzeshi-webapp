defmodule HamvarzeshiWeb.UserController do
  use HamvarzeshiWeb, :controller
  alias Hamvarzeshi.Gym
  alias Hamvarzeshi.User
  alias Hamvarzeshi.GymUser
  alias Hamvarzeshi.Repo
  import Ecto.Query

  def index(conn, _params) do

    gym_ids = Repo.all(
      from(
        gu in GymUser, select: gu.gym_id, where: gu.user_id == ^conn.assigns.user.id
        )
      )



    gyms = get_gym_list(gym_ids)
    total_price = calc_total(gyms)

    render(conn, "profile.html", gyms: gyms, total_price: total_price)



  end


  def get_gym_list(gym_ids) do
    list = for gym_id <- gym_ids do
      gym = Repo.all(from(gym in Gym, where: gym.id == ^gym_id))
      [gym_item] = gym
      gym_item
    end
    list
  end

  def calc_total(gyms) do
    if gyms != [] do
      Enum.map(gyms, fn(x) -> Integer.parse(x.price) end )
        |> Enum.map(fn(x) -> x |> elem(0) end)
        |> Enum.reduce(fn(x, acc) -> x + acc end)
    else
      0
    end

  end

  def show_detail(conn, %{"user_id" => user_id, "gym_id" => gym_id} = params) do
    id1 = String.to_integer(user_id)
    id2 = String.to_integer(gym_id)
    [gym_struct] = Repo.all(
      from(
        gu in GymUser, where: gu.user_id == ^id1 and gu.gym_id == ^id2
        )
      )

    #IO.inspect(gym_struct)
    gym = Repo.get(Gym, gym_id)
    render(conn, "gym_detail.html", start_at: gym_struct.start, end_at: gym_struct.end, gym: gym)

  end



end
