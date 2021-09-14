defmodule HamvarzeshiWeb.CommentsChannel do
  use Phoenix.Channel
  alias Hamvarzeshi.{Repo, Gym, Comment}
  import Ecto

  def join("comments:" <> gym_id, _message, socket) do

    gym_id = String.to_integer(gym_id)
    gym = Gym
    |> Repo.get(gym_id)
    |> Repo.preload(comments: [:user])

    {:ok, %{comments: gym.comments}, assign(socket, :gym, gym)}
  end

  def handle_in(name, %{"content" => content} = message, socket) do
    gym = socket.assigns.gym
    user_id = socket.assigns.user_id
    changeset = gym
    |> Ecto.build_assoc(:comments, user_id: user_id)
    |> Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, comment} ->
        broadcast!(socket, "comments: #{socket.assigns.gym.id}:new",
        %{comment: comment})

        {:reply, :ok, socket}

      {:error, _reason} ->
        {:reply, {:error, %{error: changeset}}, socket}
    end

  end

end
