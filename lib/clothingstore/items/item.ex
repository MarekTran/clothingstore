defmodule Clothingstore.Items.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :description, :string
    field :title, :string
    field :img, :string
    field :price, :decimal
    field :stock, :integer
    many_to_many :tags, Clothingstore.Tags.Tag, join_through: "items_tags"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs \\ %{}) do
    item
    |> cast(attrs, [:title, :img, :description, :price, :stock])
    |> validate_required([:title, :img, :description, :price, :stock])
  end
end
