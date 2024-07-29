defmodule Clothingstore.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :title, :text
      add :img, :text
      add :description, :text
      add :price, :decimal
      add :stock, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
