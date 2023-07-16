defmodule CheeseCaveWeb.CheeseLiveTest do
  use CheeseCaveWeb.ConnCase

  import Phoenix.LiveViewTest
  import CheeseCave.CheesesFixtures

  @create_attrs %{name: "some name", cheese_name: "some cheese_name", press_done_date: "2023-07-15", start_aging_date: "2023-07-15"}
  @update_attrs %{name: "some updated name", cheese_name: "some updated cheese_name", press_done_date: "2023-07-16", start_aging_date: "2023-07-16"}
  @invalid_attrs %{name: nil, cheese_name: nil, press_done_date: nil, start_aging_date: nil}

  defp create_cheese(_) do
    cheese = cheese_fixture()
    %{cheese: cheese}
  end

  describe "Index" do
    setup [:create_cheese]

    test "lists all cheeses", %{conn: conn, cheese: cheese} do
      {:ok, _index_live, html} = live(conn, ~p"/cheeses")

      assert html =~ "Listing Cheeses"
      assert html =~ cheese.name
    end

    test "saves new cheese", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/cheeses")

      assert index_live |> element("a", "New Cheese") |> render_click() =~
               "New Cheese"

      assert_patch(index_live, ~p"/cheeses/new")

      assert index_live
             |> form("#cheese-form", cheese: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#cheese-form", cheese: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/cheeses")

      html = render(index_live)
      assert html =~ "Cheese created successfully"
      assert html =~ "some name"
    end

    test "updates cheese in listing", %{conn: conn, cheese: cheese} do
      {:ok, index_live, _html} = live(conn, ~p"/cheeses")

      assert index_live |> element("#cheeses-#{cheese.id} a", "Edit") |> render_click() =~
               "Edit Cheese"

      assert_patch(index_live, ~p"/cheeses/#{cheese}/edit")

      assert index_live
             |> form("#cheese-form", cheese: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#cheese-form", cheese: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/cheeses")

      html = render(index_live)
      assert html =~ "Cheese updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes cheese in listing", %{conn: conn, cheese: cheese} do
      {:ok, index_live, _html} = live(conn, ~p"/cheeses")

      assert index_live |> element("#cheeses-#{cheese.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#cheeses-#{cheese.id}")
    end
  end

  describe "Show" do
    setup [:create_cheese]

    test "displays cheese", %{conn: conn, cheese: cheese} do
      {:ok, _show_live, html} = live(conn, ~p"/cheeses/#{cheese}")

      assert html =~ "Show Cheese"
      assert html =~ cheese.name
    end

    test "updates cheese within modal", %{conn: conn, cheese: cheese} do
      {:ok, show_live, _html} = live(conn, ~p"/cheeses/#{cheese}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Cheese"

      assert_patch(show_live, ~p"/cheeses/#{cheese}/show/edit")

      assert show_live
             |> form("#cheese-form", cheese: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#cheese-form", cheese: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/cheeses/#{cheese}")

      html = render(show_live)
      assert html =~ "Cheese updated successfully"
      assert html =~ "some updated name"
    end
  end
end
