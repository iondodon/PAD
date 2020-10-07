defmodule Gateway.Router do
    use Plug.Router
    use Plug.ErrorHandler
    alias Gateway.Service

    plug(:match)

    plug(
        Plug.Parsers,
        parsers: [:json, :urlencoded, :multipart],
        pass: ["text/*"],
        json_decoder: Jason
    )

    plug(:dispatch)

    defp handle_menus_requests(conn) do
        method = String.to_atom(String.downcase(conn.method, :default))
        binary_body = Jason.encode!(conn.body_params)

        case Service.request(method, conn.request_path, binary_body, conn.req_headers) do
            {:ok, response} ->
                send_resp(conn, response.status_code, response.body)
            {:error, _reason} ->
                send_resp(conn, 503, "Service error!")
        end
    end

    post "/register" do
        address = conn.body_params["address"]
        send_resp(conn, 200, address)
    end

    match "/menus*_rest" do
        handle_menus_requests(conn)
    end

    match _ do
        send_resp(conn, 404, "404. not found!")
    end

    defp handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
        send_resp(conn, 502, "Something went wrong!")
    end
end
