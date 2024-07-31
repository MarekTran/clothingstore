defmodule Clothingstore.Items.ItemsTags do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items_tags" do
    field :item_id, :id
    field :tag_id, :id

    timestamps()
  end

  @doc false
  def changeset(items_tags, attrs) do
    items_tags
    |> cast(attrs, [:item_id, :tag_id])
    |> validate_required([:item_id, :tag_id])
    |> unique_constraint([:item_id, :tag_id]) # Ensure the combination is unique
  end
end
