defmodule Ui.FirmwareTest do
  use Ui.DataCase

  alias Ui.Firmware

  describe "buttons" do
    alias Ui.Firmware.Button

    import Ui.FirmwareFixtures

    @invalid_attrs %{action: nil, gpio_pin: nil, target: nil}

    test "list_buttons/0 returns all buttons" do
      button = button_fixture()
      assert Firmware.list_buttons() == [button]
    end

    test "get_button!/1 returns the button with given id" do
      button = button_fixture()
      assert Firmware.get_button!(button.id) == button
    end

    test "create_button/1 with valid data creates a button" do
      valid_attrs = %{action: "some action", gpio_pin: "some gpio_pin", target: "some target"}

      assert {:ok, %Button{} = button} = Firmware.create_button(valid_attrs)
      assert button.action == "some action"
      assert button.gpio_pin == "some gpio_pin"
      assert button.target == "some target"
    end

    test "create_button/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Firmware.create_button(@invalid_attrs)
    end

    test "update_button/2 with valid data updates the button" do
      button = button_fixture()

      update_attrs = %{
        action: "some updated action",
        gpio_pin: "some updated gpio_pin",
        target: "some updated target"
      }

      assert {:ok, %Button{} = button} = Firmware.update_button(button, update_attrs)
      assert button.action == "some updated action"
      assert button.gpio_pin == "some updated gpio_pin"
      assert button.target == "some updated target"
    end

    test "update_button/2 with invalid data returns error changeset" do
      button = button_fixture()
      assert {:error, %Ecto.Changeset{}} = Firmware.update_button(button, @invalid_attrs)
      assert button == Firmware.get_button!(button.id)
    end

    test "delete_button/1 deletes the button" do
      button = button_fixture()
      assert {:ok, %Button{}} = Firmware.delete_button(button)
      assert_raise Ecto.NoResultsError, fn -> Firmware.get_button!(button.id) end
    end

    test "change_button/1 returns a button changeset" do
      button = button_fixture()
      assert %Ecto.Changeset{} = Firmware.change_button(button)
    end
  end
end
