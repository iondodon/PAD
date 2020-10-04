defmodule Gateway.Router do
  use Plug.Router
  alias Gateway.Service

  plug :match
  plug :dispatch

  get "/hello" do
    case Service.get(conn.request_path) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        send_resp(conn, 200, body)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        send_resp(conn, 404, "404. not found")
      {:error, %HTTPoison.Error{reason: reason}} ->
        send_resp(conn, 500, reason)
    end
  end

  match _ do
    IO.inspect(conn)
    IO.inspect(conn.request_path)
    send_resp(conn, 404, "404. not found")
  end
end
