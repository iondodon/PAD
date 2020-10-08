defmodule Cache.ConnectionListener do
    use GenServer
    require Logger

    # https://gist.github.com/t4sk/f84ae820b0f1a92a5c828baacbb95ce1

    @cache_port Application.get_env(:cache_port, :port, 6666)  
  
    def start_link([]) do
      GenServer.start_link(__MODULE__, %{socket: nil})
    end
  
    def init(state) do
      {:ok, socket} = :gen_tcp.listen(@cache_port, [:binary, active: true])
      send(self(), :accept)
  
      Logger.info "Accepting connection on port #{@cache_port}..."
      {:ok, %{state | socket: socket}}
    end
  
    def handle_info(:accept, %{socket: socket} = state) do
      {:ok, _} = :gen_tcp.accept(socket)
  
      Logger.info "Client connected"
      {:noreply, state}
    end
  
    def handle_info({:tcp, socket, data}, state) do
      Logger.info "Received #{data}"
      Logger.info "Sending it back"
  
      :ok = :gen_tcp.send(socket, data)
  
      {:noreply, state}
    end
  
    def handle_info({:tcp_closed, _}, state), do: {:stop, :normal, state}
    def handle_info({:tcp_error, _}, state), do: {:stop, :normal, state}
end