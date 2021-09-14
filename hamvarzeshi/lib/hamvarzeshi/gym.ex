defmodule Hamvarzeshi.Gym do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hamvarzeshi.User

  schema "gyms" do
    field :description, :string
    field :name, :string
    field :photo, :string
    field :rating, :integer
    field :price, :string
    belongs_to :user, User
    field :count_rated, :integer
    many_to_many :users, User, join_through: "gyms_users"
    has_many :comments, Hamvarzeshi.Comment

    timestamps()
  end

  @doc false
  def changeset(gym, attrs) do
    gym
    |> cast(attrs, [:name, :photo, :description, :rating, :price, :count_rated])
    |> validate_required([:name, :description, :price])
  end
end
