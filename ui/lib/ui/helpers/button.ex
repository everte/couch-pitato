defmodule Ui.Helpers.Button do
  require Ecto.Query
  import Ecto.Query
  alias Ui.Firmware.Button
  alias Ui.Repo

  def find_by_gpio_pin(gpio_pin) do
    query = from(b in Button, where: b.gpio_pin == ^gpio_pin)
    Repo.all(query)
  end
end
