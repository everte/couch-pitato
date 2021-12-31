defmodule Ui.Helpers.Light do
  require Ecto.Query
  import Ecto.Query
  alias Ui.Firmware.Light
  alias Ui.Firmware.LightState
  alias Ui.Repo

  #def find_by_gpio_pin(gpio_pin) do
  #  query = from(b in Button, where: b.gpio_pin == ^gpio_pin)
  #  Repo.all(query)
  #end

  def get_all_lights() do
     Light |> Repo.all
  end

  def initial_state_from_db() do
    lights = get_all_lights()
    for light <- lights, into: %{} do
      state = %LightState{}
      state = %{state | rgb: light.rgb }
      state = %{state | r: 0 }
      state = %{state | g: 0 }
      state = %{state | b: 0 }
      state = %{state | w: 0 }
      state = %{state | dmx_channel_w: light.dmx_channel_w }
      state = %{state | dmx_channel_r: light.dmx_channel_r }
      state = %{state | dmx_channel_g: light.dmx_channel_g }
      state = %{state | dmx_channel_b: light.dmx_channel_b }
      {String.to_atom(light.name), state}
    end
  end

  def get_default_values(light) do
    query = from(l in Light, where: l.name == ^light)
    light = Repo.one(query)
    {light.default_r, light.default_g, light.default_b, light.default_w}
  end

end
