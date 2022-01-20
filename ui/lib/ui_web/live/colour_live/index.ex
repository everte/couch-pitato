defmodule UiWeb.ColourLive.Index do
  use UiWeb, :live_view

  alias Ui.Firmware
  alias Ui.Firmware.Colour

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :colours, list_colours())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Colour")
    |> assign(:colour, Firmware.get_colour!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Colour")
    |> assign(:colour, %Colour{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Colours")
    |> assign(:colour, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    colour = Firmware.get_colour!(id)
    {:ok, _} = Firmware.delete_colour(colour)

    {:noreply, assign(socket, :colours, list_colours())}
  end

  defp list_colours do
    Firmware.list_colours()
  end
end
