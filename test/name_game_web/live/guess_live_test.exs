defmodule NameGameWeb.GuessLiveTest do
  use NameGameWeb.ConnCase

  import Phoenix.LiveViewTest

  alias NameGame.Game

  @create_attrs %{name: "some name", score: 42}
  @update_attrs %{name: "some updated name", score: 43}
  @invalid_attrs %{name: nil, score: nil}

  defp fixture(:guess) do
    {:ok, guess} = Game.create_guess(@create_attrs)
    guess
  end

  defp create_guess(_) do
    guess = fixture(:guess)
    %{guess: guess}
  end

  describe "Index" do
    setup [:create_guess]

    test "lists all guesses", %{conn: conn, guess: guess} do
      {:ok, _index_live, html} = live(conn, Routes.guess_index_path(conn, :index))

      assert html =~ "Listing Guesses"
      assert html =~ guess.name
    end

    test "saves new guess", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.guess_index_path(conn, :index))

      assert index_live |> element("a", "New Guess") |> render_click() =~
        "New Guess"

      assert_patch(index_live, Routes.guess_index_path(conn, :new))

      assert index_live
             |> form("#guess-form", guess: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#guess-form", guess: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.guess_index_path(conn, :index))

      assert html =~ "Guess created successfully"
      assert html =~ "some name"
    end

    test "updates guess in listing", %{conn: conn, guess: guess} do
      {:ok, index_live, _html} = live(conn, Routes.guess_index_path(conn, :index))

      assert index_live |> element("#guess-#{guess.id} a", "Edit") |> render_click() =~
        "Edit Guess"

      assert_patch(index_live, Routes.guess_index_path(conn, :edit, guess))

      assert index_live
             |> form("#guess-form", guess: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#guess-form", guess: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.guess_index_path(conn, :index))

      assert html =~ "Guess updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes guess in listing", %{conn: conn, guess: guess} do
      {:ok, index_live, _html} = live(conn, Routes.guess_index_path(conn, :index))

      assert index_live |> element("#guess-#{guess.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#guess-#{guess.id}")
    end
  end

  describe "Show" do
    setup [:create_guess]

    test "displays guess", %{conn: conn, guess: guess} do
      {:ok, _show_live, html} = live(conn, Routes.guess_show_path(conn, :show, guess))

      assert html =~ "Show Guess"
      assert html =~ guess.name
    end

    test "updates guess within modal", %{conn: conn, guess: guess} do
      {:ok, show_live, _html} = live(conn, Routes.guess_show_path(conn, :show, guess))

      assert show_live |> element("a", "Edit") |> render_click() =~
        "Edit Guess"

      assert_patch(show_live, Routes.guess_show_path(conn, :edit, guess))

      assert show_live
             |> form("#guess-form", guess: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#guess-form", guess: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.guess_show_path(conn, :show, guess))

      assert html =~ "Guess updated successfully"
      assert html =~ "some updated name"
    end
  end
end
