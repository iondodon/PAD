defmodule Gateway.Router do
    use Plug.Router
    use Plug.ErrorHandler
    alias Gateway.Service

    plug(:match)

    plug(
        Plug.Parsers, 
        parsers: [:json], 
        pass: ["application/json"], 
        json_decoder: Utils.NoOpJsonDecoder
    )

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

    defp handle_menus_requests(conn) do
        body = conn.body_params["_json"] || ""
        method = String.to_atom(String.downcase(conn.method, :default))
        
        case Service.request(method, conn.request_path, body, conn.req_headers) do
            {:ok, response} -> 
                send_resp(conn, response.status_code, response.body)
            {:error, _reason} -> 
                send_resp(conn, 503, "Service error")
        end
    end

    match "/menus*_rest" do
        handle_menus_requests(conn)
    end

    match _ do
        send_resp(conn, 404, "404. not found")
    end

    defp handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
        send_resp(conn, 502, "Something went wronggg")
    end
end
