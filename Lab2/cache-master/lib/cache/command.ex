defmodule Cache.Command do
    require Logger
    alias Cache.Storage

    def parse(line, slave_socket) do
        case String.split(line) do
            ["PUSHSLAVE"] -> {:ok, {:pushslave, slave_socket}}
            _ -> {:ok, line}
        end
    end

    def run({:pushslave, client_socket}) do
        Logger.info("PUSHSLAVE #{Kernel.inspect(client_socket)}")
        Storage.push_slave(client_socket)
    end

    # Command execution on slave
    def run(command) do
        Logger.info("EXECUTE #{command} on slave")
    end
end
