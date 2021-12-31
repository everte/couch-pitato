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

  @doc """
  Generate a light.
  """
  def light_fixture(attrs \\ %{}) do
    {:ok, light} =
      attrs
      |> Enum.into(%{
        default_b: 42,
        default_g: 42,
        default_r: 42,
        default_w: 42,
        dmx_channel_b: 42,
        dmx_channel_g: 42,
        dmx_channel_r: 42,
        dmx_channel_w: 42,
        name: "some name",
        rgb: true,
        ui_group_name: "some ui_group_name",
        ui_group_order: 42,
        ui_name: "some ui_name",
        ui_order: 42
      })
      |> Ui.Firmware.create_light()

    light
  end
end
