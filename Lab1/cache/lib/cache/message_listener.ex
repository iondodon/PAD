defmodule Cache.MessageListener do
    require Logger

    # client means client socket

    @data_length 0
    
    def serve(client) do
        response = with {:ok, data} <- read_from_client(client),
                   {:ok, command} <- Cache.Command.parse(data),
                   do: Cache.Command.run(command)
        
        send_to_client(client, response)
        
        serve(client)
    end
    
    defp read_from_client(client) do
        :gen_tcp.recv(client, @data_length)
    end
    
    defp send_to_client(client, {:error, :unknown_command}) do
        # Known error; write to the client
        :gen_tcp.send(client, "UNKNOWN COMMAND\r\n")
    end
    
    defp send_to_client(_client, {:error, :closed}) do
        # The connection was closed, exit politely
        exit(:shutdown)
    end
    
    defp send_to_client(client, {:error, error}) do
        # Unknown error; write to the client and exit
        Logger.error(error)
        :gen_tcp.send(client, "ERROR\r\n")
        exit(error)
    end

    defp send_to_client(client, result) do
        :gen_tcp.send(client, Jason.encode!(result))
    end
end