defmodule Clothingstore.ItemsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Clothingstore.Items` context.
  """

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        description: "some description",
        img: "some img",
        price: "120.5",
        stock: 42,
        title: "some title"
      })
      |> Clothingstore.Items.create_item()

    item
  end
end
