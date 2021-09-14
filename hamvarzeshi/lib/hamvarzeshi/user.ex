defmodule Hamvarzeshi.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hamvarzeshi.Gym

  @derive {Jason.Encoder, only: [:email]}

  schema "users" do
    field :email, :string
    field :name, :string
    field :provider, :string
    field :token, :string
    has_many :gyms, Gym #this on is for admin
    many_to_many :gymss, Gym, join_through: "gyms_users" #this one is for normal user
    has_many :comments, Hamvarzeshi.Comment

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :token, :provider])
    |> validate_required([:email, :token, :provider])
  end
end
