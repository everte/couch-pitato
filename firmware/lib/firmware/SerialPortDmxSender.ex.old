defmodule SerialPortDmxSender do
  use GenServer
  @module __MODULE__
  def start_link(port_name) do
    GenServer.start_link(@module, port_name, [name: @module])
  end
  def start(port_name \\ "/dev/cu.usbserial-A10K372S") do
    start_link(port_name)
  end
  def stop do
    GenServer.stop @module
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
    :ok = Circuits.UART.open(uart_pid, port_name, speed: 250000, stop_bits: 2, parity: :none)
    :timer.send_interval(100, self(), {:send_dmx})
    :global.register_name("serial_dmx", self())
    {:ok, %{
        dmx_data: <<>>,
        uart_pid: uart_pid,
        send_count: 100}}
  end

  def get_state() do
    GenServer.call(@module, :get_state)
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:update_dmx_data, <<>>}, state), do: {:noreply, %{state | dmx_data: <<>>}}
  def handle_cast({:update_dmx_data, dmx_data}, state) do
    {:noreply, %{state | dmx_data: <<00>> <> String.pad_trailing(<<dmx_data::binary>>, 512, "\0")}}
  end
  def handle_info({:send_dmx}, %{dmx_data: <<>>} = state), do: {:noreply, state}
  def handle_info({:send_dmx}, %{dmx_data: dmx_data, uart_pid: uart_pid} = state) do
    try do
      Circuits.UART.send_break(uart_pid, 12)
      Circuits.UART.write(uart_pid, dmx_data)
    rescue
      e -> e |> IO.inspect(label: "serial send error: ")
    end
    send_count = Map.get(state, :send_count, 100) - 1
    if send_count > 0 do
      {:noreply, Map.put(state, :send_count, send_count) }
    else
      {:noreply, %{state | send_count: 100}, :hibernate }
    end
  end
  def handle_info({:circuits_uart, _serial_port, _msg}, state), do: {:noreply, state}
  def terminate(reason,  %{uart_pid: uart_pid} = state) do
    Circuits.UART.stop(uart_pid)
    {:noreply, state}
  end
end
