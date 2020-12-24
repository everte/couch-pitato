defmodule Controller do
  use GenServer

  @server  Controller.PubSub
  @channel "events"

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end


  def init(:ok) do
    IO.puts("Init")
    Phoenix.PubSub.subscribe(Controller.PubSub, "events")
    lights = %{:living => [ui_name: "licht bureau", ui_group: "leefruimte", ui_order: 1, r: 0, g: 0, b: 0, w: 190, dw: 120],
                :kitchen => [ui_name: "keukeneiland", ui_group: "leefruimte", ui_order: 2, r: 0, g: 0, b: 0, w: 220, dw: 200],
                :bathroom => [ui_name: "bathroom light", ui_group: "badkamer", ui_order: 3, r: 0, g: 0, b: 0, w: 90, dw: 240]
  }
    {:ok, lights}
  end

  def handle_info(:get_state, state) do
    IO.puts("Get state request")
    Phoenix.PubSub.broadcast(Controller.PubSub, "events", {:state, state})
    {:noreply, state}
  end

  def handle_info({:off, id}, state) do
    IO.puts("handling off for #{id}")
    id = String.to_atom(id)
    IO.inspect(state)
    IO.inspect(id)
    IO.inspect(Map.get(state, id))

    {_ ,state} = Map.get_and_update(state, id, fn current ->
      IO.inspect(current)
      updatedkw = Keyword.put(current, :w, 0)
      {current, updatedkw}
    end)
    Phoenix.PubSub.broadcast(@server, @channel, {:state, state})

    {:noreply, state}
  end

  def handle_info({:on, id}, state) do
    IO.puts("handling on for #{id}")
    id = String.to_atom(id)

    {_ ,state} = Map.get_and_update(state, id, fn current ->
      IO.inspect(current)
      {:ok, default} = Keyword.fetch(current, :dw)
      updatedkw = Keyword.put(current, :w, default)
      {current, updatedkw}
    end)
    Phoenix.PubSub.broadcast(@server, @channel, {:state, state})

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
