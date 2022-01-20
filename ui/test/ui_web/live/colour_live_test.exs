defmodule UiWeb.ColourLiveTest do
  use UiWeb.ConnCase

  import Phoenix.LiveViewTest
  import Ui.FirmwareFixtures

  @create_attrs %{hex: "some hex"}
  @update_attrs %{hex: "some updated hex"}
  @invalid_attrs %{hex: nil}

  defp create_colour(_) do
    colour = colour_fixture()
    %{colour: colour}
  end

  describe "Index" do
    setup [:create_colour]

    test "lists all colours", %{conn: conn, colour: colour} do
      {:ok, _index_live, html} = live(conn, Routes.colour_index_path(conn, :index))

      assert html =~ "Listing Colours"
      assert html =~ colour.hex
    end

    test "saves new colour", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.colour_index_path(conn, :index))

      assert index_live |> element("a", "New Colour") |> render_click() =~
               "New Colour"

      assert_patch(index_live, Routes.colour_index_path(conn, :new))

      assert index_live
             |> form("#colour-form", colour: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#colour-form", colour: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.colour_index_path(conn, :index))

      assert html =~ "Colour created successfully"
      assert html =~ "some hex"
    end

    test "updates colour in listing", %{conn: conn, colour: colour} do
      {:ok, index_live, _html} = live(conn, Routes.colour_index_path(conn, :index))

      assert index_live |> element("#colour-#{colour.id} a", "Edit") |> render_click() =~
               "Edit Colour"

      assert_patch(index_live, Routes.colour_index_path(conn, :edit, colour))

      assert index_live
             |> form("#colour-form", colour: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#colour-form", colour: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.colour_index_path(conn, :index))

      assert html =~ "Colour updated successfully"
      assert html =~ "some updated hex"
    end

    test "deletes colour in listing", %{conn: conn, colour: colour} do
      {:ok, index_live, _html} = live(conn, Routes.colour_index_path(conn, :index))

      assert index_live |> element("#colour-#{colour.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#colour-#{colour.id}")
    end
  end

  describe "Show" do
    setup [:create_colour]

    test "displays colour", %{conn: conn, colour: colour} do
      {:ok, _show_live, html} = live(conn, Routes.colour_show_path(conn, :show, colour))

      assert html =~ "Show Colour"
      assert html =~ colour.hex
    end

    test "updates colour within modal", %{conn: conn, colour: colour} do
      {:ok, show_live, _html} = live(conn, Routes.colour_show_path(conn, :show, colour))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Colour"

      assert_patch(show_live, Routes.colour_show_path(conn, :edit, colour))

      assert show_live
             |> form("#colour-form", colour: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#colour-form", colour: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.colour_show_path(conn, :show, colour))

      assert html =~ "Colour updated successfully"
      assert html =~ "some updated hex"
    end
  end
end
