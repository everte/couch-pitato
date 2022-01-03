defmodule Ui.Helpers.LightState do
  def rgbval(lightstate) do
    "#" <>
      String.pad_leading(Integer.to_string(lightstate.r, 16), 2, "0") <>
      String.pad_leading(Integer.to_string(lightstate.g, 16), 2, "0") <>
      String.pad_leading(Integer.to_string(lightstate.b, 16), 2, "0")
  end

  def rgbval(r, g, b) do
    "#" <>
      String.pad_leading(Integer.to_string(r, 16), 2, "0") <>
      String.pad_leading(Integer.to_string(g, 16), 2, "0") <>
      String.pad_leading(Integer.to_string(b, 16), 2, "0")
  end
end
