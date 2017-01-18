defmodule Web.Repo.Migrations.CreateChallenge do
  use Ecto.Migration

  def change do
    create table(:challenges) do
      add :name, :string
      add :details, :string
      add :descriptions, {:array, :string}

      timestamps()
    end

  end
end
