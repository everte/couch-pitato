defmodule UiWeb.Lights do
  use UiWeb, :live_view

  @server  Ui.PubSub
  @channel "events"
  @step 8

  @impl true
  def mount(_params, _session, socket) do
    IO.puts("Mount")
    Phoenix.PubSub.subscribe(@server, @channel)
    Phoenix.PubSub.broadcast(@server, @channel, :get_state)
    {:ok, assign(socket, lights: %{})}
  end

  @impl true
  def handle_info({:state, lights}, state) do
    IO.puts("Received a lights state update")
    state = assign(state, lights: lights)
    {:noreply, state}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

  @impl true
  def handle_event("off-" <> id, _, socket) do
    IO.puts("off for id #{id}")
    Phoenix.PubSub.broadcast(@server, @channel, {:off, id})
    {:noreply, socket}
  end

  def handle_event("on-" <> id, _, socket) do
    IO.puts("on for id #{id}")
    Phoenix.PubSub.broadcast(@server, @channel, {:on, id})
    {:noreply, socket}
  end

  def handle_event("down-" <> id, _, socket) do
    IO.puts("down for id #{id}")
    Phoenix.PubSub.broadcast(@server, @channel, {:down, id, @step})
    {:noreply, socket}
  end


  def handle_event("up-" <> id, _, socket) do
    IO.puts("up for id #{id}")
    Phoenix.PubSub.broadcast(@server, @channel, {:up, id, @step})
    {:noreply, socket}
  end


  def handle_event("change-" <> id, %{"slider" => slider_val}, socket) do
    IO.puts("change for #{id} and slider value: #{slider_val}")
    Phoenix.PubSub.broadcast(@server, @channel, {:value, id, slider_val})
    {:noreply, socket}
  end

  def handle_event(event, _, socket) do
    IO.puts("catch all event")
    IO.inspect(event)
    {:noreply, socket}
  end
end
