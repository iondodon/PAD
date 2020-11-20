defmodule Cache.Command do
    require Logger
    alias Cache.Storage

    @recv_length 0

    # Command execution on slave
    def run(command) do
        slave_name = Storage.rpoplpush("slaves", "slaves")
        slave = Storage.get(slave_name)
        Logger.info("EXECUTE #{command} on slave #{Kernel.inspect(slave)}")
        :gen_tcp.send(slave, command)
        {:ok, response_from_slave} = :gen_tcp.recv(slave, @recv_length)
        response_from_slave
    end
end
