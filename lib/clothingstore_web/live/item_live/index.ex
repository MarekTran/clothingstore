defmodule ClothingstoreWeb.ItemLive.Index do
  use ClothingstoreWeb, :live_view

  alias Clothingstore.Items
  # alias Clothingstore.Items.Item

  def mount(_params, _session, socket) do
    # user_id = socket.assigns.current_user.id # Unused
    changeset = Items.Item.changeset(%Items.Item{})

    socket =
      socket
      |> assign(:items, Clothingstore.Items.list_items())
      |> assign(:form, to_form(changeset))
      |> assign(:formstate, to_form(changeset))
      |> assign(:uploaded_files, [])
      |> allow_upload(:photograph, accept: ~w(.jpg .jpeg .png), max_entries: 1)

    {:ok, socket}
  end

  # Populate the database with sample data
  def get_data do
    url = "https://api.escuelajs.co/api/v1/products"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, data} ->
            {:ok, data}
          {:error, error} ->
            {:error, error}
        end

      {:ok, %HTTPoison.Response{status_code: status_code}} when status_code != 200 ->
        {:error, "Request failed with status code: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def init_data do
    case get_data() do
      {:ok, data} ->

        data = Enum.filter(data, fn item ->
          item["category"]["name"] == "Clothes"
        end)

        sample_data = Enum.take(data, 10)
        clothes_with_index = Enum.with_index(sample_data)

        Enum.each(clothes_with_index, fn {item, index} ->
          category = item["category"]["name"]
          first_image_url = List.first(item["images"])
          title = item["title"]
          price = item["price"]
          description = item["description"]

          IO.puts("Stock: #{index}")
          IO.puts("Category: #{category}")
          IO.puts("First Image URL: #{first_image_url}")
          IO.puts("Title: #{title}")
          IO.puts("Price: #{price}")
          IO.puts("Description: #{description}")
          IO.puts("-------------------------------")
        end)

      {:error, error} ->
        IO.puts("Error: #{error}")
    end
  end

  def handle_event("populate", _params, socket) do
    init_data()
    {:noreply, socket}
  end

  def handle_event("submit", %{"item" => item_params}, socket) do
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
    item_params = Map.put(item_params, "img", hd(socket.assigns.uploaded_files))
    case Items.create_item(item_params) do
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

  def handle_event("validate", %{"item" => item_params}, socket) do
    IO.puts("Hit validate")
    changeset = Items.Item.changeset(%Items.Item{}, item_params)
    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photograph, ref)}
  end
end
