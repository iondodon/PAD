defmodule Cache.MessageListener do
    require Logger

    # client means client socket

    @data_length 0

    def serve(client) do
        {:ok, data} = read_from_client(client)
        {:ok, command} = Cache.Command.parse(data, client)

        case Cache.Command.run(command) do
            :slave_registered -> Logger.info("Slave registered")
            result_from_slave -> send_to_client(client, result_from_slave)
        end

        serve(client)
    end

    defp read_from_client(client) do
        :gen_tcp.recv(client, @data_length)
    end

    defp send_to_client(client, result) do
        :gen_tcp.send(client, "#{result} \r\n")
    end
end
