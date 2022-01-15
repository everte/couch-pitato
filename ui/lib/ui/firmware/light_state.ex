defmodule Ui.Firmware.LightState do
  defstruct rgb: nil,
            r: 0,
            g: 0,
            b: 0,
            w: 0,
            dmx_channel_w: nil,
            dmx_channel_r: nil,
            dmx_channel_g: nil,
            dmx_channel_b: nil,
            rgbval: ""
end
