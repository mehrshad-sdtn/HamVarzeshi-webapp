defmodule HamvarzeshiWeb.PageController do
  use HamvarzeshiWeb, :controller
  alias Hamvarzeshi.Repo
  alias Hamvarzeshi.Gym


  def index(conn, _params) do
    gyms = Repo.all(Gym)
    render(conn, "index.html", gyms: gyms)

  end

end
