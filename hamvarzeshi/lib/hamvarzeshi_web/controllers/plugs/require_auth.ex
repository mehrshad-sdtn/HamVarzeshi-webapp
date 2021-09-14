defmodule Hamvarzeshi.Plugs.RequireAuth do
  use HamvarzeshiWeb, :controller
  import Plug.Conn

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:error, "Action not allowed, you must be logged in")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()

    end
  end

end
