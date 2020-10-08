defmodule Gateway.Router do
    use Plug.Router
    use Plug.ErrorHandler
    alias Service.CircuiBreaker
    alias Gateway.RCache
    alias Gateway.Cache.RCache

    plug(:match)
    plug(
        Plug.Parsers,
        parsers: [:json, :urlencoded, :multipart],
        pass: ["text/*"],
        json_decoder: Jason
    )
    plug(:dispatch)

    defp handle_menus_requests(conn) do
        request = %{
            method: String.to_atom(String.downcase(conn.method, :default)),
            path: conn.request_path,
            body: conn.body_params,
            headers: conn.req_headers
        }

        case CircuiBreaker.request(request) do
            {:ok, response} -> send_resp(conn, response.status_code, response.body)
            {:error, _reason} -> send_resp(conn, 503, "Service error!")
        end
    end

    post "/register" do
        address = conn.body_params["address"]
        RCache.command(["LPUSH", "services", address])
        send_resp(conn, 200, address <> " registed")
    end

    match "/menus*_rest", do: handle_menus_requests(conn)
    match _, do: send_resp(conn, 404, "404. not found!")
    defp handle_errors(conn, err), do: send_resp(conn, 500, err.reason.message)
end
