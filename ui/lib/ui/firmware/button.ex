defmodule Ui.Firmware.Button do
  use Ecto.Schema
  import Ecto.Changeset

  schema "buttons" do
    field(:action, :string)
    field(:gpio_pin, :string)
    field(:target, :string)

    timestamps()
  end

  @doc false
  def changeset(button, attrs) do
    button
    |> cast(attrs, [:gpio_pin, :action, :target])
    |> validate_required([:gpio_pin, :action, :target])
  end
end
