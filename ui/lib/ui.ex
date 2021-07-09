defmodule Ui do
  require Logger
  @moduledoc """
  Ui keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  use GenServer

  @server Ui.PubSub
  @channel "events"
  @max_val 255
  @min_val 0

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end


  # TODO:
  # Configuration write and read from file:
  # File.write!("test.txt", :erlang.term_to_binary(map))
  #  File.read!("test.txt") |> :erlang.binary_to_term

  # /data dir is persisted between reboots on nerves
  # use some kind of config to make that work :)
  #

  def init(:ok) do
    IO.puts("Init")
    # read the config
    Phoenix.PubSub.subscribe(@server, "events")
    Phoenix.PubSub.subscribe(@server, "dmx")

    lights = %{:living => %Light{ui_name: "licht bureau", ui_group: "leefruimte", ui_order: 1, r: 0, g: 0, b: 0, w: 190, default_w: 120, default_r: 10, default_g: 20, default_b: 50, dmx_channel_w: 0, dmx_channel_r: 1, dmx_channel_g: 2, dmx_channel_b: 3, rgb: true},
                :kitchen => %Light{ui_name: "keukeneiland", ui_group: "leefruimte", ui_order: 2, r: 0, g: 0, b: 0, w: 220, default_w: 200, dmx_channel_w: 1, rgb: false},
                :bathroom => %Light{ui_name: "bathroom light", ui_group: "badkamer", ui_order: 3, r: 0, g: 0, b: 0, w: 90, default_w: 240, dmx_channel_w: 9, rgb: false}}

    {:ok, lights}
  end


  def handle_info({:state, lights}, state) do
    Logger.debug(state)
    Logger.debug("Received a lights state update")
    dmx_bitstring = Dmx.create_dmx_bitstring(lights)
    Logger.debug("dmx bitstring is: #{inspect dmx_bitstring}")
    Phoenix.PubSub.broadcast(@server, "dmx", {:dmx, dmx_bitstring})
    IO.inspect(dmx_bitstring)
    
    #state = assign(state, lights: lights)
    {:noreply, lights}
  end

  def handle_info(:get_state, state) do
    IO.puts("Get state request")
    Phoenix.PubSub.broadcast(@server, "events", {:state, state})
    {:noreply, state}
  end

  def handle_info(:get_lights_config, state) do
    IO.puts("Get light config request")
    # TODO: read configuration file from disk
    Phoenix.PubSub.broadcast(@server, "events", {:config, state})
    {:noreply, state}
  end


  def handle_info({:new_lights_config, lights}, state) do
    IO.puts("new config pushed")
    # TODO: save the config
    Phoenix.PubSub.broadcast(@server, "events", {:state, lights})
    {:noreply, state}
  end

  def handle_info({:off, {id, colour}}, state) do
    IO.puts("handling off for #{id} in #{colour}")
    id = String.to_existing_atom(id)
    colour = String.to_existing_atom(colour)
    IO.inspect(state)
    IO.inspect(id)
    IO.inspect(Map.get(state, id))

    {_ ,state} = Map.get_and_update(state, id, fn current ->
      updatedkw = Map.put(current, colour, 0)
      {current, updatedkw}
    end)
    Phoenix.PubSub.broadcast(@server, @channel, {:state, state})

    {:noreply, state}
  end

  def handle_info({:on, {id, colour}}, state) do
    IO.puts("handling on for #{id} in #{colour}")
    id = String.to_existing_atom(id)
    colour = String.to_existing_atom(colour)

    {_ ,state} = Map.get_and_update(state, id, fn current ->
      default = Map.get(current, :default_w)
      updatedkw = Map.put(current, colour, default)
      {current, updatedkw}
    end)
    Phoenix.PubSub.broadcast(@server, @channel, {:state, state})

    {:noreply, state}
  end

  def handle_info({:down, {id, colour}, step}, state) do
    IO.puts("handling down for #{id} #{colour}")
    id = String.to_existing_atom(id)
    colour = String.to_existing_atom(colour)

    {_ ,state} = Map.get_and_update(state, id, fn current ->
      brightness = Map.get(current, colour)
      brightness = max(@min_val, brightness - step)
      updatedkw = Map.put(current, colour, brightness)
      {current, updatedkw}
    end)
    Phoenix.PubSub.broadcast(@server, @channel, {:state, state})

    {:noreply, state}
  end


  def handle_info({:up, {id, colour}, step}, state) do
    IO.puts("handling up for #{id} #{colour}")
    id = String.to_existing_atom(id)
    colour = String.to_existing_atom(colour)

    {_ ,state} = Map.get_and_update(state, id, fn current ->
      brightness = Map.get(current, colour)
      brightness = min(@max_val, brightness + step)
      updatedkw = Map.put(current, colour, brightness)
      {current, updatedkw}
    end)
    Phoenix.PubSub.broadcast(@server, @channel, {:state, state})

    {:noreply, state}
  end

  def handle_info({:value, {id, colour}, new_value}, state) do
    IO.puts("handling value for #{id} #{colour}")
    id = String.to_existing_atom(id)
    colour = String.to_existing_atom(colour)
    new_value = String.to_integer(new_value)

    {_ ,state} = Map.get_and_update(state, id, fn current ->
      {current, Map.put(current, colour, new_value)}
    end)
    Phoenix.PubSub.broadcast(@server, @channel, {:state, state})
    {:noreply, state}
  end


  def handle_info({:button, _}, state) do
    IO.puts "Button pressed!"
    Phoenix.PubSub.broadcast(@server, "events", state)
    {:noreply, state}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

end
