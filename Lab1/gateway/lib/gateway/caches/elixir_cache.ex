defmodule Gateway.Cache.ECache do
    use GenServer, restart: :permanent
    require Logger

    @recv_data_length 0

    @ip Application.get_env(:gateway, :elixir_cache_host, {127, 0, 0, 1})
    @port Application.get_env(:gateway, :elixir_cache_port, 6666)
    
    def start_link(_args) do
       GenServer.start_link(__MODULE__, :nil, name: Gateway.Cache.ECache)
    end

    def command(command) do
        GenServer.call(__MODULE__, {:command, command})
    end


    # callbacks on server side

    def init(_args) do
        case :gen_tcp.connect(@ip, @port, [:binary, active: false]) do
            {:ok, socket} -> 
                Logger.info("Connected to elixir cache")
                {:ok, socket}
            {:error, _reason} -> 
                Logger.info("Not able to connect to elixir cache")
                :ignore
        end
    end

    def handle_call({:command, command}, _from, socket) do
        response = with :gen_tcp.send(socket, command <> "\n"), 
                    do: :gen_tcp.recv(socket, @recv_data_length)
        
        case response do
            {:error, reason} ->
                {:stop, Kernel.inspect(reason), Kernel.inspect(reason), socket}
            {:ok, data} ->
                {:reply, data, socket}
        end
    end
end