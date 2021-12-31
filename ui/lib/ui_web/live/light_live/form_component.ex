defmodule UiWeb.LightLive.FormComponent do
  use UiWeb, :live_component

  alias Ui.Firmware

  @impl true
  def update(%{light: light} = assigns, socket) do
    changeset = Firmware.change_light(light)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"light" => light_params}, socket) do
    changeset =
      socket.assigns.light
      |> Firmware.change_light(light_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"light" => light_params}, socket) do
    save_light(socket, socket.assigns.action, light_params)
  end

  defp save_light(socket, :edit, light_params) do
    case Firmware.update_light(socket.assigns.light, light_params) do
      {:ok, _light} ->
        {:noreply,
         socket
         |> put_flash(:info, "Light updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_light(socket, :new, light_params) do
    case Firmware.create_light(light_params) do
      {:ok, _light} ->
        {:noreply,
         socket
         |> put_flash(:info, "Light created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
