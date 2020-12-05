defmodule Cache.MasterCommandListener do
    require Logger

    @recv_length 0

    def serve(master_socket) do
        result = with {:ok, data} <- read_from_master(master_socket),
                   {:ok, command} <- Cache.Command.parse(data),
                   do: Cache.Command.run(command)

        send_to_master(master_socket, result)

        serve(master_socket)
    end

    defp reconnect_to_master() do
        Supervisor.terminate_child(Cache.BaseSupervisor, Cache.ConnectionToMaster)
        Supervisor.restart_child(Cache.BaseSupervisor, Cache.ConnectionToMaster)
    end

    defp read_from_master(master_socket) do
        :gen_tcp.recv(master_socket, @recv_length)
    end

    defp send_to_master(master_socket, {:error, :unknown_command}) do
        # Unknown command error; write to the client
        :gen_tcp.send(master_socket, "UNKNOWN COMMAND\r\n\n")
    end

    defp send_to_master(_master_socket, {:error, :closed}) do
        # The connection was closed, restart connection task
        Logger.error(:closed)
        reconnect_to_master()
    end

    defp send_to_master(_master_socket, {:error, error}) do
        # Unknown error; write to the client and exit
        Logger.error(error)
        reconnect_to_master()
    end

    defp send_to_master(master_socket, result) do
        response = Utils.type_and_value(result)
        :gen_tcp.send(master_socket, "#{response} \r\n")
    end
end
