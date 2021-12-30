defmodule Ui.FirmwareFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ui.Firmware` context.
  """

  @doc """
  Generate a button.
  """
  def button_fixture(attrs \\ %{}) do
    {:ok, button} =
      attrs
      |> Enum.into(%{
        action: "some action",
        gpio_pin: "some gpio_pin",
        target: "some target"
      })
      |> Ui.Firmware.create_button()

    button
  end
end
