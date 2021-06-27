defmodule Dmx do
 
  def create_dmx_bitstring(lights) do
    IO.inspect(lights)
    dmx_prep = 
    Enum.map(lights, fn {_key, light} -> case light.rgb do                                  
        true -> 
          [{light.dmx_channel_w, light.w}, {light.dmx_channel_r, light.r}, {light.dmx_channel_g, light.g}, {light.dmx_channel_b, light.b}]
        false -> [{light.dmx_channel_w, light.w}]       
        end
      end)
      |> List.flatten
      |> Enum.sort(&(&2 > &1))
    
    IO.inspect(dmx_prep) 
    {channel_count, _val} = List.last(dmx_prep)
    IO.puts("channel count is: #{channel_count}")
    channels = for _ <- 0..channel_count, into: [], do: 0
    dmx_list = Enum.reduce(dmx_prep, channels, fn {channel, value}, acc -> List.replace_at(acc, channel, value) end)
    for value <- dmx_list, into: <<>>, do: <<value>>
  end
end
