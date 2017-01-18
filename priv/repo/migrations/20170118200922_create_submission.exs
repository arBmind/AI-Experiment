defmodule Web.Repo.Migrations.CreateSubmission do
  use Ecto.Migration

  def change do
    create table(:submissions) do
      add :challenge_id, :integer
      add :author, :string
      add :archive, :map

      timestamps()
    end

  end
end
