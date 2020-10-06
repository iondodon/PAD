defmodule Gateway.Router do
  use Plug.Router
  alias Gateway.Service

  plug(Plug.Parsers, parsers: [:urlencoded, :json], pass: ["text/*"], json_decoder: Jason)
  plug(:match)
  plug(:dispatch)

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

  post "/menus" do
    ops = [{"Content-Type", "application/json"}]
    {:ok, body} = Jason.encode(conn.body_params)
    {:ok, response} = Service.post("/menus", body, ops)
    {:ok, encoded_body} = Jason.encode(response.body)
    send_resp(conn, 201, encoded_body)
  end

  match _ do
    IO.inspect(conn)
    IO.inspect(conn.request_path)
    send_resp(conn, 404, "404. not found")
  end
end
