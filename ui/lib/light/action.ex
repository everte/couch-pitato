defmodule Light.Action do
  require Ecto.Query
  import Ecto.Query
  alias Ui.Firmware.Button
  alias Ui.Repo

  @server Ui.PubSub
  @channel "events"

  def apply_action(pin_number) do
    pin_number = Integer.to_string(pin_number)
    query = from(b in Button, where: b.gpio_pin == ^pin_number)

    Repo.all(query)
    |> Enum.each(fn button -> execute_action(button.action, button.target) end)
  end

  def execute_action("onoff", target) do
    Phoenix.PubSub.broadcast(@server, @channel, {:onoff, {target}})
  end
end
