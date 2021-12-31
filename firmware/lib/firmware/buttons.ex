defmodule Firmware.Buttons do
  use Agent
  require Logger
  use GenServer

  @server Ui.PubSub
  @channel "events"

  def init_inputs() do
    pins = Enum.to_list(0..1) ++ Enum.to_list(4..27)

    Enum.map(pins, fn pin ->
      {:ok, gpio} = Circuits.GPIO.open(pin, :input, pull_mode: :pulldown)
      Circuits.GPIO.set_interrupts(gpio, :both)
      gpio
    end)
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    state = {init_inputs(), %{}}
    {:ok, state}
  end

  def handle_info({:circuits_gpio, pin_number, timestamp, 1}, {refs, map}) do
    Logger.debug("button gpio #{pin_number} pressed at #{timestamp} with value 1")

    {_, map} =
      Map.get_and_update(map, pin_number, fn current ->
        {current, timestamp}
      end)

    {:noreply, {refs, map}}
  end

  def handle_info({:circuits_gpio, pin_number, timestamp, 0}, {refs, map}) do
    Logger.debug("button gpio #{pin_number} pressed at #{timestamp} with value 0")
    prev_time = Map.get(map, pin_number, 0)

    # debounce: 20ms after last press we can assume button is 'stable'
    if timestamp - prev_time > 20_000_000 and prev_time != 0 do
      Logger.info("Actual button off for #{pin_number}")

      Phoenix.PubSub.broadcast(@server, @channel, {:button, pin_number})
    end

    {_, map} =
      Map.get_and_update(map, pin_number, fn current ->
        {current, timestamp}
      end)

    {:noreply, {refs, map}}
  end

  def handle_info(_, state) do
    IO.inspect(state, label: "catchall handle info")
    {:norpely, state}
  end
end
