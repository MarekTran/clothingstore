defmodule Clothingstore.Items.ItemsTags do
  use Ecto.Schema

  schema "items_tags" do
    field :item_id, :id
    field :tag_id, :id

    timestamps()
  end
end
