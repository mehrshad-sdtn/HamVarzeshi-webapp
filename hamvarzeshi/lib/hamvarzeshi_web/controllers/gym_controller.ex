defmodule HamvarzeshiWeb.GymController do
  use HamvarzeshiWeb, :controller


  alias Hamvarzeshi.Gym
  alias Hamvarzeshi.Repo
  import Ecto

  plug Hamvarzeshi.Plugs.RequireAuth when action in [:new, :edit, :edit, :update, :create, :delete]
  plug :check_owner when action in [:update, :delete, :edit]
  #----------------------------| CRUD |------------------------------------------------------
  def show(conn, %{"id" => gym_id}) do
    gym = Repo.get!(Gym, gym_id)
    render(conn, "show.html", gym: gym)
  end


  def new(conn, _params) do
    changeset = Gym.changeset(%Gym{}, %{})
    render(conn, "add_gym.html", changeset: changeset)
  end


  def edit(conn, %{"id" => gym_id}) do
    gym = Repo.get!(Gym, gym_id)
    changeset = Gym.changeset(gym, %{})
    render(conn, "edit.html", changeset: changeset, gym: gym)
  end



  def update(conn, %{"id" => gym_id, "gym" => gym}) do
    old_data = Repo.get!(Gym, gym_id)
    params = update_photo(gym)
    changeset = Gym.changeset(old_data, params)
    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "gym records updated")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "invalid data")
        |> render("edit.html", changeset: changeset, gym: old_data)

    end
  end



  def delete(conn, %{"id" => gym_id}) do
    Repo.get!(Gym, gym_id) |> Repo.delete!
    conn
    |> put_flash(:info, "Gym Deleted")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def create(conn, %{"gym" => gym_params}) do
    if gym_params["photo"] do
        params = put_new_photo(gym_params)

        changeset = build_changeset(conn, params)
        insert_if_nil(conn, changeset)

    else
        changeset = build_changeset(conn, gym_params)
        insert_if_nil(conn, changeset)
    end
  end


  #-------------------------| HELPING FUNCTIONS |-------------------------------

  def update_photo(gym) do
    if gym["photo"] do
      params = put_new_photo(gym)
      params
    else
      params = gym
      params
    end

  end


  def put_new_photo(gym) do
    path_upload = gym["photo"]
    path_str = "uploads/#{path_upload.filename}"
    File.cp(path_upload.path, Path.absname(path_str))
    params = %{gym|"photo" => path_str}
    params
  end


  def build_changeset(conn, params) do
      conn.assigns.user |> Ecto.build_assoc(:gyms) |> Gym.changeset(params)
  end

  def insert_if_nil(conn, changeset) do
      case Repo.get_by(Gym, name: changeset.changes.name) do
        nil -> insert_record(conn, changeset)
        gym -> already_exist(conn)
      end
  end

  def insert_record(conn, changeset) do
    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "gym successfully added")
        |> redirect(to: Routes.page_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "kojaa!?")
        |> redirect(to: Routes.gym_path(conn, :new))


    end
  end


  def already_exist(conn) do
    conn
    |> put_flash(:error, "gym has already been added")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  #-----------------------| PLUGS |-------------------------
  def check_owner(conn, _params) do
    %{params: %{"id" => gym_id}} = conn

    if user_owns_gym(conn, gym_id) do
      conn
    else
      conn
      |> put_flash(:error, "Permissions denied")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()


    end
  end

  def user_owns_gym(conn, gym_id) do
    Repo.get(Gym, gym_id).user_id == conn.assigns.user.id
  end

end
