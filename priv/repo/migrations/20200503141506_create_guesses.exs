defmodule NameGame.Repo.Migrations.CreateGuesses do
  use Ecto.Migration

  def change do
    create table(:guesses) do
      add :name, :string
      add :score, :integer

      timestamps()
    end

  end
end
