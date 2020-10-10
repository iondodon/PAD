defmodule Cache.MessageListener do
    require Logger

    # client means client socket
    @data_length 0
    
    def serve(client) do
        msg = with {:ok, data} <- read_from_client(client),
                   {:ok, command} <- Cache.Command.parse(data),
                   do: Cache.Command.run(command)
        
        send_to_client(client, msg)
        serve(client)
    end
    
    defp read_from_client(client) do
        {:ok, data} = :gen_tcp.recv(client, @data_length)
        data
    end

    defp send_to_client(client, {:ok, text}) do
        :gen_tcp.send(client, text)
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
        :gen_tcp.send(client, "ERROR\r\n")
        exit(error)
    end
end