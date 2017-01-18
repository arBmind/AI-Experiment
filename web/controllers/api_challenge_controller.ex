defmodule Web.ApiChallengeController do
  use Web.Web, :controller

  alias Web.Challenge

  def index(conn, _params) do
    challenges = Repo.all(Challenge)
    json conn, %{version: 1, challenges: Enum.map(challenges, &challenge_json/1)}
  end

  def challenge_json(challenge) do
    %{
      id: challenge.id,
      name: challenge.name,
      details: challenge.details,
      descriptions: challenge.descriptions
    }
  end
end
