defmodule Cache.MessageListener do
    require Logger
    @data_length 0

    def serve(client_socket) do
        {:ok, command} = read_from_client(client_socket)
        result = Cache.Command.run(command)
        send_to_client(client_socket, result)

        serve(client_socket)
    end

    defp read_from_client(client_socket) do
        :gen_tcp.recv(client_socket, @data_length)
    end

    defp send_to_client(client_socket, result) do
        :gen_tcp.send(client_socket, "#{result} \r\n")
    end
end
