defmodule Clothingstore.TagsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Clothingstore.Tags` context.
  """

  @doc """
  Generate a tag.
  """
  def tag_fixture(attrs \\ %{}) do
    {:ok, tag} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Clothingstore.Tags.create_tag()

    tag
  end
end
