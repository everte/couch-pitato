defmodule Firmware.Buttons do
  use Agent
  require Logger
  use GenServer

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

  def handle_info({:circuits_gpio, pin_number, timestamp, value}, state) do
    Logger.debug("button gpio #{pin_number} pressed at #{timestamp} with value #{value}")
    IO.inspect(state)
    {:noreply, state}
  end

  def handle_info(_, state) do
    IO.inspect(state, label: "catchall handle info")
    {:norpely, state}
  end
end
