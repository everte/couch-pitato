defmodule Ui.Repo.Migrations.CreateColours do
  use Ecto.Migration

  def change do
    create table(:colours) do
      add :hex, :string

      timestamps()
    end
  end
end
