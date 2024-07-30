defmodule Clothingstore.Items do
  @moduledoc """
  The Items context.
  """

  import Ecto.Query, warn: false
  alias Clothingstore.Repo

  alias Clothingstore.Items.Item
  alias Clothingstore.Tags.Tag
  alias Clothingstore.Items.ItemsTags


  @doc """
  Returns the list of items with tags.

  ## Examples

      iex> list_items_with_tags()
      [%Item{}, ...]

  """
  def list_items_with_tags do
    query =
      from i in Item,
        join: it in ItemsTags, on: it.item_id == i.id,
        join: t in Tag, on: t.id == it.tag_id,
        preload: [tags: t]

    Repo.all(query)
  end

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """
  def list_items do
    Repo.all(Item)
  end

  @doc """
  Gets a single item.

  Raises `Ecto.NoResultsError` if the Item does not exist.

  ## Examples

      iex> get_item!(123)
      %Item{}

      iex> get_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item!(id), do: Repo.get!(Item, id)

  @doc """
  Creates a item.

  ## Examples

      iex> create_item(%{field: value})
      {:ok, %Item{}}

      iex> create_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a item.

  ## Examples

      iex> update_item(item, %{field: new_value})
      {:ok, %Item{}}

      iex> update_item(item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a item.

  ## Examples

      iex> delete_item(item)
      {:ok, %Item{}}

      iex> delete_item(item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  @doc """
  Deletes an item by ID.

  ## Examples

      iex> delete_item(1)
      :ok

      iex> delete_item(2)
      {:error, "Unable to delete item"}

  """
  def delete_item_by_id(id) do
    case Repo.get(Item, id) do
      nil -> {:error, "Item not found"}
      item ->
        case Repo.delete(item) do
          {:ok, _} -> {:ok, "Deleted successfully"}
          {:error, _} -> {:error, "Unable to delete item"}
        end
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item changes.

  ## Examples

      iex> change_item(item)
      %Ecto.Changeset{data: %Item{}}

  """
  def change_item(%Item{} = item, attrs \\ %{}) do
    Item.changeset(item, attrs)
  end
end
