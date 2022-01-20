defmodule UiWeb.Lights do
  require Logger
  use UiWeb, :live_view
  alias Ui.Helpers.Light
  alias Ui.Firmware
  alias Ui.Firmware.Colour


  @server Ui.PubSub
  @channel "events"
  @step 8

  @impl true
  def mount(_params, _session, socket) do
    IO.puts("Mount")
    Phoenix.PubSub.subscribe(@server, @channel)
    state = assign(socket, lights: Light.get_all_lights())
    state = assign(state, lights_state: %Ui.Firmware.LightState{})
    state = assign(state, testcolour: "00ff00")
    state = push_event(state, "colors", %{colors: get_colours() })
    Phoenix.PubSub.broadcast(@server, @channel, :get_state)
    {:ok, state}
  end

  def get_colours() do
    Ui.Firmware.list_colours()
    |> Enum.map(fn  light ->  light.hex end)
  end

  @impl true
  def handle_info({:state, lights}, state) do
    Logger.debug("recevide lights state update in lights.ex:")
    state = assign(state, lights_state: lights)
    {:noreply, state}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

  @impl true
  def handle_event("off", %{"key" => key, "colour" => colour}, socket) do
    IO.puts("off for key #{key} and colour #{colour}")
    Phoenix.PubSub.broadcast(@server, @channel, {:off, {key}})
    {:noreply, socket}
  end

  def handle_event("on", %{"key" => key, "colour" => colour}, socket) do
    IO.puts("on for key #{key} and colour #{colour}")
    Phoenix.PubSub.broadcast(@server, @channel, {:on, {key}})
    {:noreply, socket}
  end

  def handle_event("down", %{"key" => key, "colour" => colour}, socket) do
    IO.puts("down for id #{key} with colour: #{colour}")
    Phoenix.PubSub.broadcast(@server, @channel, {:down, {key, colour}, @step})
    {:noreply, socket}
  end

  def handle_event("up", %{"key" => key, "colour" => colour}, socket) do
    IO.puts("up for id #{key} with colour: #{colour}")
    Phoenix.PubSub.broadcast(@server, @channel, {:up, {key, colour}, @step})
    {:noreply, socket}
  end

  def handle_event("change", %{"slider" => slider_val, "key" => key, "colour" => colour}, socket) do
    IO.puts("change for #{key}, colour #{colour} and slider value: #{slider_val}")
    Phoenix.PubSub.broadcast(@server, @channel, {:value, {key, colour}, slider_val})
    {:noreply, socket}
  end

  def handle_event("change", %{"colour" => "#" <> colour, "key" => key}, socket) do
    IO.puts("handle colour change")
    IO.inspect(colour)
    IO.inspect(key)
    <<r::binary-size(2), g::binary-size(2), b::binary-size(2)>> = colour
    {r, _} = Integer.parse(r, 16)
    {g, _} = Integer.parse(g, 16)
    {b, _} = Integer.parse(b, 16)
    IO.inspect(r)
    Phoenix.PubSub.broadcast(@server, @channel, {:colours, {key, {r, g, b}}})
    {:noreply, socket}
  end

  def handle_event("like_colour", %{ "hex" => colour} = col, socket) do
    Logger.info("Liked colour #{colour}")
    # col = %Colour{}
    # col = %{col | hex: colour}
    case Firmware.create_colour(col) do
      {:ok, _} -> Logger.debug("successfully inserted new colour")
      {:error, _} -> Logger.debug("error inserting colour")
    end

    socket = push_event(socket, "colors", %{colors: get_colours() })
    {:noreply, socket}
  end

  def handle_event(event, data, socket) do
    IO.puts("catch all event")
    IO.inspect(event)
    IO.inspect(data)
    {:noreply, socket}
  end

  def get_colour(lights, name) do
    Map.get(lights, String.to_atom(name), %Ui.Firmware.LightState{})
    |> Map.get(:rgbval)
  end
end
