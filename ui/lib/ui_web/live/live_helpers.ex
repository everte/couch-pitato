defmodule UiWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `UiWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal UiWeb.ButtonLive.FormComponent,
        id: @button.id || :new,
        action: @live_action,
        button: @button,
        return_to: Routes.button_index_path(@socket, :index) %>
  """
  def live_modal(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(UiWeb.ModalComponent, modal_opts)
  end
end
