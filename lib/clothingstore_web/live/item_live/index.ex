defmodule ClothingstoreWeb.ItemLive.Index do
  use ClothingstoreWeb, :live_view

  # alias Clothingstore.Items
  # alias Clothingstore.Items.Item

  def mount(_params, _session, socket) do
    # user_id = socket.assigns.current_user.id # Unused

    socket =
      socket
      |> assign(:items, Clothingstore.Items.list_items())

    {:ok, socket}
  end
end
