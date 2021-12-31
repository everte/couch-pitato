defmodule Firmware.Dmx do
  require Logger
  use GenServer

  @module __MODULE__
  def start_link(_) do
    port_name = "/dev/ttyUSB0"
    GenServer.start_link(@module, port_name, name: @module)
  end

  def start(port_name \\ "/dev/ttyUSB0") do
    start_link(port_name)
  end

  def stop do
    GenServer.stop(@module)
  end

  def restart(port_name) do
    stop()
    start(port_name)
  end

  def send_dmx(dmx_data) do
    GenServer.cast(@module, {:update_dmx_data, dmx_data})
  end

  def init(port_name) do
    {:ok, uart_pid} = Circuits.UART.start_link()
    Process.flag(:trap_exit, true)
    :ok = Circuits.UART.open(uart_pid, port_name, speed: 250_000, stop_bits: 2, parity: :none)
    # :timer.send_interval(50, self(), {:send_dmx})
    :global.register_name("serial_dmx", self())
    GenServer.cast(@module, {:send_dmx})
    Phoenix.PubSub.subscribe(Ui.PubSub, "dmx")
    {:ok, %{dmx_data: <<100>>, uart_pid: uart_pid}}
  end

  def get_state() do
    GenServer.call(@module, :get_state)
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:update_dmx_data, <<>>}, state), do: {:noreply, %{state | dmx_data: <<>>}}

  def handle_cast({:update_dmx_data, dmx_data}, state) do
    {:noreply,
     %{state | dmx_data: <<00>> <> String.pad_trailing(<<dmx_data::binary>>, 512, "\0")}}
  end

  def handle_info({:send_dmx}, %{dmx_data: <<>>} = state), do: {:noreply, state}

  def handle_cast({:send_dmx}, %{dmx_data: dmx_data, uart_pid: uart_pid} = state) do
    try do
      Circuits.UART.send_break(uart_pid, 12)
      Circuits.UART.write(uart_pid, dmx_data)
    rescue
      e -> e |> IO.inspect(label: "serial send error: ")
    end

    GenServer.cast(@module, {:send_dmx})
    {:noreply, state}
  end

  def handle_info({:circuits_uart, _serial_port, _msg}, state), do: {:noreply, state}

  def terminate(reason, %{uart_pid: uart_pid} = state) do
    Circuits.UART.stop(uart_pid)
    {:noreply, state}
  end

  def handle_info({:dmx, dmx}, state) do
    Logger.debug("received dmx - going to cast to serial port!")
    Logger.debug("dmx: #{inspect(dmx)}")
    send_dmx(dmx)
    {:noreply, state}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end
end
