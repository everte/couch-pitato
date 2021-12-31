defmodule Ui do
  require Logger
  alias Ui.Helpers.Light
  alias Ui.Helpers.Action

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

  def init(:ok) do
    IO.puts("Init")

    lights = Light.initial_state_from_db()

    Phoenix.PubSub.subscribe(@server, "events")
    Phoenix.PubSub.subscribe(@server, "dmx")

    # Phoenix.PubSub.broadcast(@server, "events", :get_state)

    {:ok, lights}
  end

  def refresh_state_from_db() do
    lights = Light.initial_state_from_db()
    Phoenix.PubSub.broadcast(@server, "events", {:state, lights})
  end

  def handle_info({:state, lights}, state) do
    Logger.debug(state)
    Logger.debug("Received a lights state update")
    dmx_bitstring = Dmx.create_dmx_bitstring(lights)
    Logger.debug("dmx bitstring is: #{inspect(dmx_bitstring)}")
    Phoenix.PubSub.broadcast(@server, "dmx", {:dmx, dmx_bitstring})
    IO.inspect(dmx_bitstring)

    # state = assign(state, lights: lights)
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

  def handle_info({:off, {id}}, state) do
    Logger.debug("handling off for #{id}")
    id = String.to_existing_atom(id)

    {_, state} =
      if state[id].rgb == false do
        Map.get_and_update(state, id, fn current ->
          updatedkw = Map.put(current, :w, 0)
          {current, updatedkw}
        end)
      else
        Map.get_and_update(state, id, fn current ->
          updatedkw = Map.put(current, :r, 0) |> Map.put(:g, 0) |> Map.put(:b, 0)
          {current, updatedkw}
        end)
      end

    Phoenix.PubSub.broadcast(@server, @channel, {:state, state})
    {:noreply, state}
  end

  def handle_info({:on, {id}}, state) do
    Logger.debug("handling on for #{id}")
    {r, g, b, w } = Light.get_default_values(id) |> IO.inspect(label: "default rgbw")
    id = String.to_existing_atom(id)

    {_, state} =
      if state[id].rgb == false do
        Map.get_and_update(state, id, fn current ->
          updatedkw = Map.put(current, :w, w)
          {current, updatedkw}
      end)
      else
        Map.get_and_update(state, id, fn current ->
          updatedkw = Map.put(current, :r, r) |> Map.put(:g, g) |> Map.put(:b, b)
          {current, updatedkw}
        end)
      end

    Phoenix.PubSub.broadcast(@server, @channel, {:state, state})
    {:noreply, state}
  end

  def handle_info({:onoff, {id}}, state) do
    Logger.debug("handling onoff for #{id}")
    id_atom = String.to_existing_atom(id)

    light = state[id_atom]

    cond do
      Map.get(light, :w) == 0 && Map.get(light, :r) == 0 && Map.get(light, :g) == 0 && Map.get(light, :b) == 0 -> Phoenix.PubSub.broadcast(@server, @channel, {:on, {id}})
      Map.get(light, :w) != 0 || Map.get(light, :r) != 0 || Map.get(light, :g) != 0 || Map.get(light, :b) != 0 -> Phoenix.PubSub.broadcast(@server, @channel, {:off, {id}})
    end

    {:noreply, state}
  end

  def handle_info({:down, {id, colour}, step}, state) do
    IO.puts("handling down for #{id} #{colour}")
    id = String.to_existing_atom(id)
    colour = String.to_existing_atom(colour)

    {_, state} =
      Map.get_and_update(state, id, fn current ->
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

    {_, state} =
      Map.get_and_update(state, id, fn current ->
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

    {_, state} =
      Map.get_and_update(state, id, fn current ->
        {current, Map.put(current, colour, new_value)}
      end)

    Phoenix.PubSub.broadcast(@server, @channel, {:state, state})
    {:noreply, state}
  end

  def handle_info({:colours, {id, {r, g, b}}}, state) do
    IO.puts("Handling colour change for #{id} with #{r}, #{g}, #{b}")
    id = String.to_existing_atom(id)

    rgbval =
      "#" <> Integer.to_string(r, 16) <> Integer.to_string(g, 16) <> Integer.to_string(b, 16)

    {_, state} =
      Map.get_and_update(state, id, fn current ->
        updated = Map.put(current, :r, r)
        updated = Map.put(updated, :g, g)
        updated = Map.put(updated, :b, b)
        updated = Map.put(updated, :rgbval, rgbval)
        {current, updated}
      end)

    Phoenix.PubSub.broadcast(@server, @channel, {:state, state})
    {:noreply, state}
  end

  def handle_info({:button, pin_number}, state) do
    Logger.info("Button pin #{pin_number} pressed - received broadcast!")
    Action.apply_action(pin_number)
    {:noreply, state}
  end

  def handle_info(msg, state) do
    Logger.debug("catch all")
    IO.inspect(msg)
    {:noreply, state}
  end
end
