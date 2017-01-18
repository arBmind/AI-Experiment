defmodule Web.Challenge do
  use Web.Web, :model

  schema "challenges" do
    field :name, :string
    field :details, :string
    field :descriptions, {:array, :string}

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :details, :descriptions])
    |> validate_required([:name, :details, :descriptions])
  end
end
