defmodule UiWeb.LightLive.Index do
  use UiWeb, :live_view

  alias Ui.Firmware
  alias Ui.Firmware.Light

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :lights, list_lights())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Light")
    |> assign(:light, Firmware.get_light!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Light")
    |> assign(:light, %Light{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Lights")
    |> assign(:light, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    light = Firmware.get_light!(id)
    {:ok, _} = Firmware.delete_light(light)

    {:noreply, assign(socket, :lights, list_lights())}
  end

  defp list_lights do
    Firmware.list_lights()
  end
end
