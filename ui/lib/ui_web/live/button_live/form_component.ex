defmodule UiWeb.ButtonLive.FormComponent do
  use UiWeb, :live_component

  alias Ui.Firmware

  @impl true
  def update(%{button: button} = assigns, socket) do
    changeset = Firmware.change_button(button)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"button" => button_params}, socket) do
    changeset =
      socket.assigns.button
      |> Firmware.change_button(button_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"button" => button_params}, socket) do
    save_button(socket, socket.assigns.action, button_params)
  end

  defp save_button(socket, :edit, button_params) do
    case Firmware.update_button(socket.assigns.button, button_params) do
      {:ok, _button} ->
        {:noreply,
         socket
         |> put_flash(:info, "Button updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_button(socket, :new, button_params) do
    case Firmware.create_button(button_params) do
      {:ok, _button} ->
        {:noreply,
         socket
         |> put_flash(:info, "Button created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
