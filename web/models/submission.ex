defmodule Web.Submission do
  use Web.Web, :model

  schema "submissions" do
    field :challenge_id, :integer
    field :author, :string
    field :archive, {:array, :map}

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:challenge_id, :author, :archive])
    |> validate_required([:challenge_id, :author, :archive])
  end
end
