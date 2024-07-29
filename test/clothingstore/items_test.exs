defmodule Clothingstore.ItemsTest do
  use Clothingstore.DataCase

  alias Clothingstore.Items

  describe "items" do
    alias Clothingstore.Items.Item

    import Clothingstore.ItemsFixtures

    @invalid_attrs %{description: nil, title: nil, img: nil, price: nil, stock: nil}

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Items.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Items.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      valid_attrs = %{description: "some description", title: "some title", img: "some img", price: "120.5", stock: 42}

      assert {:ok, %Item{} = item} = Items.create_item(valid_attrs)
      assert item.description == "some description"
      assert item.title == "some title"
      assert item.img == "some img"
      assert item.price == Decimal.new("120.5")
      assert item.stock == 42
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Items.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title", img: "some updated img", price: "456.7", stock: 43}

      assert {:ok, %Item{} = item} = Items.update_item(item, update_attrs)
      assert item.description == "some updated description"
      assert item.title == "some updated title"
      assert item.img == "some updated img"
      assert item.price == Decimal.new("456.7")
      assert item.stock == 43
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Items.update_item(item, @invalid_attrs)
      assert item == Items.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Items.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Items.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Items.change_item(item)
    end
  end
end