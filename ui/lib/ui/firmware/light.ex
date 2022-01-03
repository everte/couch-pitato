defmodule Ui.Firmware.Light do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lights" do
    field(:default_b, :integer)
    field(:default_g, :integer)
    field(:default_r, :integer)
    field(:default_w, :integer)
    field(:dmx_channel_b, :integer)
    field(:dmx_channel_g, :integer)
    field(:dmx_channel_r, :integer)
    field(:dmx_channel_w, :integer)
    field(:name, :string)
    field(:rgb, :boolean, default: false)
    field(:ui_group_name, :string)
    field(:ui_group_order, :integer)
    field(:ui_name, :string)
    field(:ui_order, :integer)

    timestamps()
  end

  @doc false
  def changeset(light, attrs) do
    light
    |> cast(attrs, [
      :name,
      :ui_name,
      :ui_group_name,
      :ui_group_order,
      :ui_order,
      :default_w,
      :default_r,
      :default_g,
      :default_b,
      :dmx_channel_w,
      :dmx_channel_r,
      :dmx_channel_g,
      :dmx_channel_b,
      :rgb
    ])
    |> validate_required([
      :name,
      :ui_name,
      :ui_group_name,
      :ui_group_order,
      :ui_order,
      :default_w,
      :default_r,
      :default_g,
      :default_b,
      :dmx_channel_w,
      :dmx_channel_r,
      :dmx_channel_g,
      :dmx_channel_b,
      :rgb
    ])
  end
end
