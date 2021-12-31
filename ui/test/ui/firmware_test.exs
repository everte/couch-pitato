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

  describe "lights" do
    alias Ui.Firmware.Light

    import Ui.FirmwareFixtures

    @invalid_attrs %{default_b: nil, default_g: nil, default_r: nil, default_w: nil, dmx_channel_b: nil, dmx_channel_g: nil, dmx_channel_r: nil, dmx_channel_w: nil, name: nil, rgb: nil, ui_group_name: nil, ui_group_order: nil, ui_name: nil, ui_order: nil}

    test "list_lights/0 returns all lights" do
      light = light_fixture()
      assert Firmware.list_lights() == [light]
    end

    test "get_light!/1 returns the light with given id" do
      light = light_fixture()
      assert Firmware.get_light!(light.id) == light
    end

    test "create_light/1 with valid data creates a light" do
      valid_attrs = %{default_b: 42, default_g: 42, default_r: 42, default_w: 42, dmx_channel_b: 42, dmx_channel_g: 42, dmx_channel_r: 42, dmx_channel_w: 42, name: "some name", rgb: true, ui_group_name: "some ui_group_name", ui_group_order: 42, ui_name: "some ui_name", ui_order: 42}

      assert {:ok, %Light{} = light} = Firmware.create_light(valid_attrs)
      assert light.default_b == 42
      assert light.default_g == 42
      assert light.default_r == 42
      assert light.default_w == 42
      assert light.dmx_channel_b == 42
      assert light.dmx_channel_g == 42
      assert light.dmx_channel_r == 42
      assert light.dmx_channel_w == 42
      assert light.name == "some name"
      assert light.rgb == true
      assert light.ui_group_name == "some ui_group_name"
      assert light.ui_group_order == 42
      assert light.ui_name == "some ui_name"
      assert light.ui_order == 42
    end

    test "create_light/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Firmware.create_light(@invalid_attrs)
    end

    test "update_light/2 with valid data updates the light" do
      light = light_fixture()
      update_attrs = %{default_b: 43, default_g: 43, default_r: 43, default_w: 43, dmx_channel_b: 43, dmx_channel_g: 43, dmx_channel_r: 43, dmx_channel_w: 43, name: "some updated name", rgb: false, ui_group_name: "some updated ui_group_name", ui_group_order: 43, ui_name: "some updated ui_name", ui_order: 43}

      assert {:ok, %Light{} = light} = Firmware.update_light(light, update_attrs)
      assert light.default_b == 43
      assert light.default_g == 43
      assert light.default_r == 43
      assert light.default_w == 43
      assert light.dmx_channel_b == 43
      assert light.dmx_channel_g == 43
      assert light.dmx_channel_r == 43
      assert light.dmx_channel_w == 43
      assert light.name == "some updated name"
      assert light.rgb == false
      assert light.ui_group_name == "some updated ui_group_name"
      assert light.ui_group_order == 43
      assert light.ui_name == "some updated ui_name"
      assert light.ui_order == 43
    end

    test "update_light/2 with invalid data returns error changeset" do
      light = light_fixture()
      assert {:error, %Ecto.Changeset{}} = Firmware.update_light(light, @invalid_attrs)
      assert light == Firmware.get_light!(light.id)
    end

    test "delete_light/1 deletes the light" do
      light = light_fixture()
      assert {:ok, %Light{}} = Firmware.delete_light(light)
      assert_raise Ecto.NoResultsError, fn -> Firmware.get_light!(light.id) end
    end

    test "change_light/1 returns a light changeset" do
      light = light_fixture()
      assert %Ecto.Changeset{} = Firmware.change_light(light)
    end
  end
end
