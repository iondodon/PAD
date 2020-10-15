defmodule Service.CircuiBreaker do
    alias Gateway.HttpClient
    alias Gateway.Cache.ECache

    @scheme "http://"
    @feilures_limit Application.get_env(:gateway, :failures_limit, 3)

    def request(%{method: method, path: path, body: body, headers: headers}) do
        unless LoadBalancer.any_available? do
            raise "No service available."
        end

        service_address = LoadBalancer.next()
        url = @scheme <> service_address <> path
        
        case HttpClient.request(method, url, body, headers) do
            {:ok, response} -> {:ok, response}
            {:error, err} -> 
                update_service_state(service_address)
                {:error, err}
        end
    end

    defp update_service_state(service_address)  do
        failures = ECache.command("INCR #{cache_key(service_address)}")

        if failures >= @feilures_limit do
            ECache.command("DEL #{cache_key(service_address)}")
            ECache.command("LREM services #{service_address}")
        end
    end

    defp cache_key(address) do
        "circuit_breaker#" <> address
    end
end