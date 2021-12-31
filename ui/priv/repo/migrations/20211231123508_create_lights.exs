defmodule Ui.Repo.Migrations.CreateLights do
  use Ecto.Migration

  def change do
    create table(:lights) do
      add :name, :string
      add :ui_name, :string
      add :ui_group_name, :string
      add :ui_group_order, :integer
      add :ui_order, :integer
      add :default_w, :integer
      add :default_r, :integer
      add :default_g, :integer
      add :default_b, :integer
      add :dmx_channel_w, :integer
      add :dmx_channel_r, :integer
      add :dmx_channel_g, :integer
      add :dmx_channel_b, :integer
      add :rgb, :boolean, default: false, null: false

      timestamps()
    end
  end
end
