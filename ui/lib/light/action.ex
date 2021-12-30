defmodule Light.Action do


  @server Ui.PubSub
  @channel "events"

  def apply_action(pin_number, state) do

    {action, lights} = find_action(pin_number)

    apply_action(action, lights, state)
  end

  def find_action(pin_number) do
    # currently hardcoded
    {:onoff, ["living"]}
  end

  def apply_action(:onoff, lights, state) do
    Enum.reduce(lights, state, fn light, acc ->
        Phoenix.PubSub.broadcast(@server, @channel, {:onoff, {light}})
    end)
    state
  end
end
