defmodule HamvarzeshiWeb.ReserveController do
  use HamvarzeshiWeb, :controller
  alias Hamvarzeshi.Gym
  alias Hamvarzeshi.User
  alias Hamvarzeshi.GymUser
  alias Hamvarzeshi.Repo
  import Ecto.Query
  import Ecto
  import DateTimeParser


  def reserve(conn, %{"id" => gym_id, "start" => start_time, "end" => end_time} = params) do
    start_at = get_parsed(start_time)
    end_at = get_parsed(end_time)
    [gym_struct] = Repo.all(from(g in Gym, where: g.id == ^gym_id))
    build_and_insert(conn, gym_struct, start_at, end_at)
  end


  def cancel(conn, %{"id" => gym_id} = params) do
    id = String.to_integer(gym_id)
    [reserved] = Repo.all(
    from(
        gu in GymUser, where: gu.user_id == ^conn.assigns.user.id and gu.gym_id == ^id
        )
      )

    Repo.get!(GymUser, reserved.id) |> Repo.delete!
    conn
    |> put_flash(:info, "Reservation Canceled")
    |> redirect(to: Routes.user_path(conn, :index, conn.assigns.user.id))
  end


  def reserve_times(conn, %{"id" => gym_id} = params) do
    render(conn, "time_page.html", id: gym_id)
  end



  def build_and_insert(conn, gym, start_at, end_at) do
    user_id = conn.assigns.user.id
    changeset = GymUser.changeset(
      %GymUser{}, %{user_id: user_id, gym_id: gym.id, price: gym.price, start: start_at, end: end_at}
    )
    insert_or_refuse(conn, changeset, gym.id)
  end



  def insert_or_refuse(conn, changeset, gym_id) do
    record = Repo.all(
    from(
        gu in GymUser, where: gu.user_id == ^conn.assigns.user.id and gu.gym_id == ^gym_id
        )
      )

    case record do
      [] -> insert_record(conn, changeset)
      _ ->
      conn
      |> put_flash(:error, "already reserved")
      |> redirect(to: Routes.page_path(conn, :index))

    end
  end




  def insert_record(conn, changeset) do
    case Repo.insert(changeset) do
     {:ok, _assoc} ->
       conn
       |> put_flash(:info, "gym successfully reserved")
       |> redirect(to: Routes.user_path(conn, :index, conn.assigns.user.id))
     {:error, _reason} ->
       conn
       |> put_flash(:error, "an error occurred")
       |> redirect(to: Routes.page_path(conn, :index))

    end
  end


  def get_parsed(tuple) do
    case DateTimeParser.parse(tuple) do
      {:ok, time} -> IO.inspect(time)
    end
  end



end
