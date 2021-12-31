defmodule Ui.Helpers.LightState do

  def rgbval(lightstate) do
    "#" <> Integer.to_string(lightstate.r, 16) <> Integer.to_string(lightstate.g, 16) <> Integer.to_string(lightstate.b, 16)
  end

end
