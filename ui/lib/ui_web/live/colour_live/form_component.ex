defmodule UiWeb.ColourLive.FormComponent do
  use UiWeb, :live_component

  alias Ui.Firmware

  @impl true
  def update(%{colour: colour} = assigns, socket) do
    changeset = Firmware.change_colour(colour)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"colour" => colour_params}, socket) do
    changeset =
      socket.assigns.colour
      |> Firmware.change_colour(colour_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"colour" => colour_params}, socket) do
    IO.inspect(colour_params)
    save_colour(socket, socket.assigns.action, colour_params)
  end

  defp save_colour(socket, :edit, colour_params) do
    case Firmware.update_colour(socket.assigns.colour, colour_params) do
      {:ok, _colour} ->
        {:noreply,
         socket
         |> put_flash(:info, "Colour updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_colour(socket, :new, colour_params) do
    case Firmware.create_colour(colour_params) do
      {:ok, _colour} ->
        {:noreply,
         socket
         |> put_flash(:info, "Colour created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
