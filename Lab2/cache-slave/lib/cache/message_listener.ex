defmodule Cache.MessageListener do
    require Logger

    # client means client socket

    @recv_length 0

    def serve(client) do
        result = with {:ok, data} <- read_from_client(client),
                   {:ok, command} <- Cache.Command.parse(data),
                   do: Cache.Command.run(command)

        IO.inspect(result)

        send_to_client(client, result)

        :timer.sleep(5000)

        serve(client)
    end

    defp read_from_client(client) do
        {:ok, data} = :gen_tcp.recv(client, @recv_length)
        IO.inspect(data)
        {:ok, data}
    end

    defp send_to_client(client, {:error, :unknown_command}) do
        # Unknown command error; write to the client
        :gen_tcp.send(client, "UNKNOWN COMMAND\r\n\n")
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
        response = Utils.type_and_value(result)
        :gen_tcp.send(client, "#{response} \r\n")
    end
end
