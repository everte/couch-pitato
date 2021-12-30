defmodule UiWeb.ButtonLiveTest do
  use UiWeb.ConnCase

  import Phoenix.LiveViewTest
  import Ui.FirmwareFixtures

  @create_attrs %{action: "some action", gpio_pin: "some gpio_pin", target: "some target"}
  @update_attrs %{
    action: "some updated action",
    gpio_pin: "some updated gpio_pin",
    target: "some updated target"
  }
  @invalid_attrs %{action: nil, gpio_pin: nil, target: nil}

  defp create_button(_) do
    button = button_fixture()
    %{button: button}
  end

  describe "Index" do
    setup [:create_button]

    test "lists all buttons", %{conn: conn, button: button} do
      {:ok, _index_live, html} = live(conn, Routes.button_index_path(conn, :index))

      assert html =~ "Listing Buttons"
      assert html =~ button.action
    end

    test "saves new button", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.button_index_path(conn, :index))

      assert index_live |> element("a", "New Button") |> render_click() =~
               "New Button"

      assert_patch(index_live, Routes.button_index_path(conn, :new))

      assert index_live
             |> form("#button-form", button: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#button-form", button: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.button_index_path(conn, :index))

      assert html =~ "Button created successfully"
      assert html =~ "some action"
    end

    test "updates button in listing", %{conn: conn, button: button} do
      {:ok, index_live, _html} = live(conn, Routes.button_index_path(conn, :index))

      assert index_live |> element("#button-#{button.id} a", "Edit") |> render_click() =~
               "Edit Button"

      assert_patch(index_live, Routes.button_index_path(conn, :edit, button))

      assert index_live
             |> form("#button-form", button: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#button-form", button: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.button_index_path(conn, :index))

      assert html =~ "Button updated successfully"
      assert html =~ "some updated action"
    end

    test "deletes button in listing", %{conn: conn, button: button} do
      {:ok, index_live, _html} = live(conn, Routes.button_index_path(conn, :index))

      assert index_live |> element("#button-#{button.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#button-#{button.id}")
    end
  end

  describe "Show" do
    setup [:create_button]

    test "displays button", %{conn: conn, button: button} do
      {:ok, _show_live, html} = live(conn, Routes.button_show_path(conn, :show, button))

      assert html =~ "Show Button"
      assert html =~ button.action
    end

    test "updates button within modal", %{conn: conn, button: button} do
      {:ok, show_live, _html} = live(conn, Routes.button_show_path(conn, :show, button))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Button"

      assert_patch(show_live, Routes.button_show_path(conn, :edit, button))

      assert show_live
             |> form("#button-form", button: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#button-form", button: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.button_show_path(conn, :show, button))

      assert html =~ "Button updated successfully"
      assert html =~ "some updated action"
    end
  end
end
