defmodule ClothingstoreWeb.ItemLive.Index do
  use ClothingstoreWeb, :live_view

  alias Clothingstore.Items
  alias Clothingstore.Tags
  # alias Clothingstore.Tags.Tag
  # alias Clothingstore.Items.Item

  def mount(_params, _session, socket) do
    # changeset = Items.Item.changeset(%Items.Item{})
    # IO.inspect(Items.Item.changeset(%Items.Item{}))
    create_form_fields = %{"title" => "", "description" => "", "price" => "", "stock" => "", "tag_ids" => []}
    filter_fields = %{"price_from" => "", "price_to" => "", "tag" => "", "stock" => ""}
    tag_changeset = Tags.Tag.changeset(%Tags.Tag{})

    socket =
      socket
      |> assign(:tag_form, to_form(tag_changeset))
      |> assign(:filter_params, to_form(filter_fields))
      |> assign(:alltags, Clothingstore.Tags.list_tags())
      |> assign(:items, Clothingstore.Items.list_items_with_tags())
      |> assign(:form, to_form(create_form_fields))
      # |> assign(:formstate, to_form(changeset))
      |> assign(:uploaded_files, [])
      |> allow_upload(:photograph, accept: ~w(.jpg .jpeg .png), max_entries: 1)

    {:ok, socket}
  end

  def price_filter(items, from, to) do
    # +-1 is a terrible hack for inclusive comparison
    case {from, to} do
      {"" , ""} -> items
      {from, ""} -> Enum.filter(items, fn item ->
        Decimal.compare(item.price, String.to_integer(from) - 1) == :gt
      end)
      {"", to} -> Enum.filter(items, fn item ->
        Decimal.compare(item.price, String.to_integer(to) + 1) == :lt
      end)
      {from, to} -> Enum.filter(items, fn item -> Decimal.compare(item.price, String.to_integer(from) - 1) == :gt and Decimal.compare(item.price, String.to_integer(to) + 1) == :lt end)
    end
  end


  def stock_filter(items, in_stock_only) do
    case in_stock_only do
      "true" -> Enum.filter(items, fn item -> item.stock > 0 end)
      _ -> items
    end
  end

  def tag_filter(items, tag_id) do
    case tag_id do
      "" -> items
      _ -> Enum.filter(items, fn item -> Enum.any?(item.tags, fn tag -> tag.id == String.to_integer(tag_id) end) end)
    end
  end

  def handle_event("clear_filter", _params, socket) do
    socket = socket
    # |> assign(:items, Clothingstore.Items.list_items_with_tags())
    |> update(:items, fn _ -> Clothingstore.Items.list_items_with_tags() end)
    # |> assign(:filter_params, to_form(filter_fields))
    |> update(:filter_params, fn _ -> to_form(%{"price_from" => "", "price_to" => "", "tag" => "", "stock" => ""}) end)
    |> put_flash(:info, "Filter cleared!")

    {:noreply, socket}
  end

  def handle_event("set_filter", filter_params, socket) do
    IO.inspect(filter_params, label: "Filter params")
    # Get items
    items = Clothingstore.Items.list_items_with_tags()
    filtered_items = items
    |> price_filter(filter_params["price_from"], filter_params["price_to"])
    |> stock_filter(filter_params["stock"])
    |> tag_filter(filter_params["tag"])

    # Update socket items assign
    socket = socket |> update(:items, fn _ -> filtered_items end) |> assign(:filter_params, to_form(filter_params)) |> put_flash(:info, "Filter set!")
    {:noreply, socket}
  end



  def handle_event("submit", item_form_params, socket) do
    # Handle file upload
    # TODO: Assert 1 file, postpone copy until after db entry
    uploaded_files =
      consume_uploaded_entries(socket, :photograph, fn %{path: path}, _entry ->
        # Explode path
        original_file_name = Path.basename(path, Path.extname(path))
        IO.puts("Original file name: #{original_file_name}")

        dest = Path.join(Application.app_dir(:clothingstore, "priv/static/uploads"), original_file_name)
        IO.puts("Copying file to #{dest}")
        File.cp!(path, dest)

        {:ok, "uploads/#{original_file_name}"}
      end)

    # Update socket with uploaded file
    socket = update(socket, :uploaded_files, fn existing_files ->
      existing_files ++ uploaded_files
    end)

    # Handle db entry, need to add img field
    item_form_params = Map.put(item_form_params, "img", hd(socket.assigns.uploaded_files))

    # Handle Tag db entry and association
    IO.inspect(item_form_params, label: "Before create item")
    case Items.create_item_with_tags(item_form_params) do
      {:ok, _item} ->
        socket = socket
        |> put_flash(:info, "Item created successfully.")
        |> push_navigate(to: ~p"/items")

        {:noreply, socket}

      {:error, changeset} ->
        socket = socket
        |> put_flash(:error, "Something went terribly wrong.")
        |> assign(:form, to_form(changeset))

        {:noreply, socket}
    end
  end

  def handle_event("validate", item_form_params, socket) do
    IO.puts("Hit validate")
    # changeset = Items.Item.changeset(%Items.Item{}, item_params)
    {:noreply, assign(socket, :form, to_form(item_form_params))}
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photograph, ref)}
  end

  def handle_event("delete_item", %{"id" => id}, socket) do
    IO.puts("Hit Delete by id")
    case Items.delete_item_by_id(id) do
      {:ok, _} ->
        IO.puts("Removing #{id} from socket assigns")
        old_length = length(socket.assigns.items)
        IO.puts("Old length: #{old_length}")
        items = Enum.reject(socket.assigns.items, fn item ->
          item.id == String.to_integer(id) end)
        IO.puts("New length: #{length(items)}")

        # Use update/3 function to update the :items assign
        socket = update(socket, :items, fn _items -> items end)
        IO.inspect(socket.assigns.items, label: "Updated socket assigns items")

        {:noreply, socket |> put_flash(:info, "Item deleted")}

      {:error, reason} ->
        {:noreply, put_flash(socket, :error, "Failed to delete item: #{reason}")}
    end
  end

  def handle_event("submit_tag", %{"tag" => tag_params}, socket) do
    IO.inspect(tag_params, label: "Tag params")
    case Tags.create_tag(tag_params) do
      {:ok, _tag} ->
        socket = socket
        |> put_flash(:info, "Tag created successfully.")
        |> push_navigate(to: ~p"/items")

        {:noreply, socket}

      {:error, changeset} ->
        socket = socket
        |> put_flash(:error, "Tag creation failed.")
        |> assign(:tag_form, to_form(changeset))

        {:noreply, socket}
    end
  end

  def handle_event("delete_tag", %{"id" => id}, socket) do
    case Tags.delete_tag_by_id(id) do
      {:ok, _} ->
        IO.puts("Removing #{id} from socket assigns")
        old_length = length(socket.assigns.alltags)
        tags = Enum.reject(socket.assigns.alltags, fn tag -> tag.id == String.to_integer(id) end)

        # Use update/3 function to update the :items assign
        socket = update(socket, :alltags, fn _tags -> tags end)
        IO.inspect(socket.assigns.alltags, label: "Updated socket assigns tags")

        {:noreply, socket |> put_flash(:info, "Tag deleted")}

      {:error, reason} ->
        {:noreply, put_flash(socket, :error, "Failed to delete tag: #{reason}")}
    end
  end
end
