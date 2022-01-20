defmodule UiWeb.ColourLive.Show do
  use UiWeb, :live_view

  alias Ui.Firmware

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:colour, Firmware.get_colour!(id))}
  end

  defp page_title(:show), do: "Show Colour"
  defp page_title(:edit), do: "Edit Colour"
end
