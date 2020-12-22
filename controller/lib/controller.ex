defmodule Controller do
  use GenServer
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end


  def init(:ok) do
    IO.puts("Init")
    Phoenix.PubSub.subscribe(Controller.PubSub, "events")
    lights = %{:living => "living"}
    {:ok, {:state, lights}}
  end

  def handle_info({:get_state, _}, state) do
    IO.puts "Test!"
    IO.inspect(state)
    Phoenix.PubSub.broadcast(Controller.PubSub, "events", state)
    {:noreply, state}
  end

  def handle_info({:button, _}, state) do
    IO.puts "Button pressed!"
    IO.inspect(state)
    Phoenix.PubSub.broadcast(Controller.PubSub, "events", state)
    {:noreply, state}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
