defmodule Ui.Repo.Migrations.AddUniqueColour do
  use Ecto.Migration

  def change do
    create unique_index(:colours, [:hex])
  end
end
