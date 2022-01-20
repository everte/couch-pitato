defmodule Ui.Firmware.Colour do
  use Ecto.Schema
  import Ecto.Changeset

  schema "colours" do
    field :hex, :string

    timestamps()
  end

  @doc false
  def changeset(colour, attrs) do
    colour
    |> cast(attrs, [:hex])
    |> validate_required([:hex])
    |> unique_constraint(:hex)
  end
end
