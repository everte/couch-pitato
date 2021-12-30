defmodule Ui.Repo.Migrations.CreateButtons do
  use Ecto.Migration

  def change do
    create table(:buttons) do
      add :gpio_pin, :string
      add :action, :string
      add :target, :string

      timestamps()
    end
  end
end
