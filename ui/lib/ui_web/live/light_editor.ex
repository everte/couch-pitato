defmodule UiWeb.LightEditor do
  use UiWeb, :live_view

  @server Ui.PubSub
  @channel "events"

  @impl true
  def mount(_params, _session, socket) do
    IO.puts("Mount")
    Phoenix.PubSub.subscribe(@server, @channel)
    Phoenix.PubSub.broadcast(@server, @channel, :get_lights_config)
    {:ok, assign(socket, lights: %{})}
  end

  @impl true
  def handle_info({:config, lights}, state) do
    IO.puts("Received a lights state update")
    state = assign(state, lights: lights)
    {:noreply, state}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

  @impl true
  def handle_event("form-change-" <> map_key, changes, socket) do
    IO.inspect(map_key)
    IO.inspect(changes)
    lights = socket.assigns.lights
    map_key = String.to_existing_atom(map_key)
    changed_key = String.to_existing_atom(hd(changes["_target"]))
    new_value = changes[hd(changes["_target"])]

    state =
      if changed_key == :name do
        new_value = String.to_atom(new_value)
        change_key(lights, map_key, new_value)
      else
      {_ , state} = Map.get_and_update(lights, map_key, fn current ->
        new_value = changes[hd(changes["_target"])]
        IO.puts("new value for #{map_key} is #{new_value}")

        new_value =
          case changed_key do
            :dmx_channel -> String.to_integer(new_value)
            :default_w -> String.to_integer(new_value)
            _ -> new_value
          end
        updatedkw = Map.put(current, changed_key, new_value)
        {current, updatedkw}
        end)
        state
      end

    socket = assign(socket, :lights, state)
    IO.inspect(socket)
    {:noreply, socket}
  end

  def handle_event("add-row", _, socket) do
    lights = socket.assigns.lights
    lights = Map.put_new(lights, :new_light, %Light{})
    socket = assign(socket, lights: lights)
    IO.inspect(socket)
    {:noreply, socket}
  end

  def handle_event("form-save", _, socket) do
    IO.puts("trying to save light config")
    lights = socket.assigns.lights
    Phoenix.PubSub.broadcast(@server, @channel, {:new_lights_config, lights})
    {:noreply, socket}
  end

  def handle_event(event, _, socket) do
    IO.puts("catch all event")
    IO.inspect(event)
    {:noreply, socket}
  end

  def change_key(orig_map, old_key, new_key) do
    orig_map
    |> Map.delete(old_key)
    |> Map.put(new_key, orig_map[old_key])
  end

end
