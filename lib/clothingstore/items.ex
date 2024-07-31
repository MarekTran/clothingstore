defmodule Clothingstore.Items do
  @moduledoc """
  The Items context.
  """

  import Ecto.Query, warn: false
  alias Clothingstore.Repo

  alias Clothingstore.Items.Item
  alias Clothingstore.Tags.Tag
  alias Clothingstore.Items.ItemsTags



  def add_tag_to_item(item_id, tag_id) do
    %ItemsTags{}
    |> ItemsTags.changeset(%{item_id: item_id, tag_id: tag_id})
    |> Repo.insert()
  end


  def remove_tag_from_item(item_id, tag_id) do
    query = from(it in ItemsTags, where: it.item_id == ^item_id and it.tag_id == ^tag_id)
    Repo.delete_all(query)
  end

  def create_item_with_tags(attrs \\ %{}) do
    IO.inspect(attrs, label: "Received attributes")

    tag_ids = Map.get(attrs, "tag_ids", [])
    IO.inspect(tag_ids, label: "Tag IDs before processing")

    tag_ids =
      if is_list(tag_ids) do
        Enum.map(tag_ids, &String.to_integer/1)
      else
        []
      end
    IO.inspect(tag_ids, label: "Tag IDs after conversion to integers")

    tags = Repo.all(from t in Tag, where: t.id in ^tag_ids)
    IO.inspect(tags, label: "Fetched Tags")

    item_changeset = Item.changeset(%Item{}, attrs)

    Repo.transaction(fn ->
      case Repo.insert(item_changeset) do
        {:ok, item} ->
          tag_changesets = Enum.map(tag_ids, fn tag_id ->
            %ItemsTags{}
            |> ItemsTags.changeset(%{item_id: item.id, tag_id: tag_id})
          end)

          results = Enum.map(tag_changesets, &Repo.insert(&1))

          if Enum.all?(results, fn result -> match?({:ok, _}, result) end) do
            {:ok, item}
          else
            Repo.rollback("Failed to insert tag associations")
          end

        {:error, changeset} ->
          IO.inspect(changeset.errors, label: "Failed to create item")
          Repo.rollback(changeset)
      end
    end)
  end


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
