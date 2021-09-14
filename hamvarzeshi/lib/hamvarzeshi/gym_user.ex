defmodule Hamvarzeshi.GymUser do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hamvarzeshi.User
  alias Hamvarzeshi.Gym

  #@primary_key false
  schema "gyms_users" do
    belongs_to :user, User
    belongs_to :gym, Gym
    field :price, :string
    field :start, :time
    field :end, :time


    timestamps()
  end

  @doc false
  def changeset(gym_user, attrs) do
    gym_user
    |> cast(attrs, [:gym_id, :user_id, :price, :start, :end])
    |> validate_required([:gym_id, :user_id ])

  end
end
