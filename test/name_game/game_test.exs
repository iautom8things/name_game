defmodule NameGame.GameTest do
  use NameGame.DataCase

  alias NameGame.Game

  describe "guesses" do
    alias NameGame.Game.Guess

    @valid_attrs %{name: "some name", score: 42}
    @update_attrs %{name: "some updated name", score: 43}
    @invalid_attrs %{name: nil, score: nil}

    def guess_fixture(attrs \\ %{}) do
      {:ok, guess} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Game.create_guess()

      guess
    end

    test "list_guesses/0 returns all guesses" do
      guess = guess_fixture()
      assert Game.list_guesses() == [guess]
    end

    test "get_guess!/1 returns the guess with given id" do
      guess = guess_fixture()
      assert Game.get_guess!(guess.id) == guess
    end

    test "create_guess/1 with valid data creates a guess" do
      assert {:ok, %Guess{} = guess} = Game.create_guess(@valid_attrs)
      assert guess.name == "some name"
      assert guess.score == 42
    end

    test "create_guess/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Game.create_guess(@invalid_attrs)
    end

    test "update_guess/2 with valid data updates the guess" do
      guess = guess_fixture()
      assert {:ok, %Guess{} = guess} = Game.update_guess(guess, @update_attrs)
      assert guess.name == "some updated name"
      assert guess.score == 43
    end

    test "update_guess/2 with invalid data returns error changeset" do
      guess = guess_fixture()
      assert {:error, %Ecto.Changeset{}} = Game.update_guess(guess, @invalid_attrs)
      assert guess == Game.get_guess!(guess.id)
    end

    test "delete_guess/1 deletes the guess" do
      guess = guess_fixture()
      assert {:ok, %Guess{}} = Game.delete_guess(guess)
      assert_raise Ecto.NoResultsError, fn -> Game.get_guess!(guess.id) end
    end

    test "change_guess/1 returns a guess changeset" do
      guess = guess_fixture()
      assert %Ecto.Changeset{} = Game.change_guess(guess)
    end
  end
end
