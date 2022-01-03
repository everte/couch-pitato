defmodule Ui.Helpers.Action do
  alias Ui.Helpers.Button

  @server Ui.PubSub
  @channel "events"

  def apply_action(pin_number) do
    pin_number = Integer.to_string(pin_number)

    Button.find_by_gpio_pin(pin_number)
    |> Enum.each(fn button -> execute_action(button.action, button.target) end)
  end

  def execute_action("onoff", target) do
    Phoenix.PubSub.broadcast(@server, @channel, {:onoff, {target}})
  end
end
