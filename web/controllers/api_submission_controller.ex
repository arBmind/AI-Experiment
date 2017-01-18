defmodule Web.ApiSubmissionController do
  use Web.Web, :controller

  alias Web.Submission

  def create(conn, %{"submission" => submission_params}) do
    changeset = Submission.changeset(%Submission{}, submission_params)

    case Repo.insert(changeset) do
      {:ok, _challenge} ->
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(200, "")
      {:error, changeset} ->
        json conn, changeset.errors
      end
  end
end

