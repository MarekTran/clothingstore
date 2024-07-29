defmodule Clothingstore.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field :name, :string
    many_to_many :items, Clothingstore.Items.Item, join_through: "items_tags"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
