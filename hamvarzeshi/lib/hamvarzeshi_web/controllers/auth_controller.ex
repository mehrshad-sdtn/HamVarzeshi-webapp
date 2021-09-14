defmodule HamvarzeshiWeb.AuthController do
  use HamvarzeshiWeb, :controller
  plug Ueberauth

  alias Hamvarzeshi.User
  alias Hamvarzeshi.Repo

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{
      email: auth.info.email,
      name: auth.info.name,
      provider: "google",
      token: auth.credentials.token

    }
    changeset = User.changeset(%User{}, user_params)
    sign_in(conn, changeset)
  end


  def sign_out(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: Routes.page_path(conn, :index))
  end



  defp sign_in(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Thank you for signing in!")
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  defp insert_or_update_user(changeset) do
    case  Repo.get_by(User, email: changeset.changes.email) do
     nil -> Repo.insert(changeset)
     user -> {:ok, user}
    end
  end

end
