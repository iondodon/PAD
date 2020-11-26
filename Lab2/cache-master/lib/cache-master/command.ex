defmodule Cache.Command do
    require Logger
    alias Cache.SlaveRegistry

    @recv_length 0
    @tag_replicas "replicas#"

    def parse(line) do
        case String.split(line) do
            ["SET", key, value] -> {:ok, {:set, key, value}}
            ["SETNX", key, value] -> {:ok, {:setnx, key, value}}
            ["GET", key] -> {:ok, {:get, key}}
            ["MGET" | keys] -> {:ok, {:mget, keys}}
            ["DEL", key] -> {:ok, {:del, key}}
            ["DEL" | keys] -> {:ok, {:del, keys}}
            ["INCR", key] -> {:ok, {:incr, key}}
            ["LPUSH", key | values] -> {:ok, {:lpush, key, values}}
            ["RPOP", key] -> {:ok, {:rpop, key}}
            ["LLEN", key] -> {:ok, {:llen, key}}
            ["LREM", key, value] -> {:ok, {:lrem, key, value}}
            ["RPOPLPUSH", key1, key2] -> {:ok, {:rpoplpush, key1, key2}}
            ["EXPIRE", key, sec] -> {:ok, {:expire, key, sec}}
            ["TTL", key] -> {:ok, {:ttl, key}}
            _ -> {:error, :unknown_command}
          end
    end

    # Command execution on slave
    def run(io_command, command)


    def run(io_command, {:set, key, value}) do
        Logger.info("SET #{key} to #{value}")
        command_hash = key
        run_on_slave(io_command, command_hash)
    end


    def run(io_command, {:setnx, key, value}) do
        Logger.info("SET  #{key} to #{value}, if not exists")
        command_hash = key
        run_on_slave(io_command, command_hash)
    end

    #on slave
    def run(io_command, {:get, key}) do
        Logger.info("GET #{key}")
        command_hash = key
        run_on_slave(io_command, command_hash)
    end


    def run(_io_command, {:mget, keys}) do
        keys_str = Enum.reduce(keys, "", fn key, keys_str -> keys_str <> key <> " " end)
        Logger.info("MGET #{keys_str}")

        values = Enum.reduce(keys, [], fn key, list ->
            command_hash = key
            response = run_on_slave("GET #{key} \n", command_hash)
            value = Utils.parse_slave_response(response)
            list ++ [value]
        end)

        IO.inspect(values)
        Enum.reduce(values, "", fn value, str ->
            str <> Kernel.inspect(value) <> " "
        end)
    end


    # Deletes multiple keys
    def run(_io_command, {:del, keys}) when is_list(keys) do
        keys_str = Enum.reduce(keys, "", fn key, keys_str -> keys_str <> key <> " " end)
        Logger.info("DELETE #{keys_str}")

        Enum.each(keys, fn key ->
            command_hash = key
            response = run_on_slave("DEL #{key} \n", command_hash)
            Logger.info("Response from slave: #{response}")
        end)

        "deleted"
    end


    def run(io_command, {:del, key}) do
        Logger.info("DELETE #{key}")
        command_hash = key
        run_on_slave(io_command, command_hash)
    end


    def run(io_command, {:incr, key}) do
        Logger.info("INCR #{key}")
        command_hash = key
        run_on_slave(io_command, command_hash)
    end


    def run(io_command, {:lpush, key, values}) do
        Logger.info("LPUSH into #{key} values #{Kernel.inspect(values)}")
        command_hash = key
        run_on_slave(io_command, command_hash)
    end


    def run(io_command, {:rpop, key}) do
        Logger.info("RPOP #{key}")
        command_hash = key
        run_on_slave(io_command, command_hash)
    end


    def run(io_command, {:llen, key}) do
        Logger.info("LLEN #{key}")
        command_hash = key
        run_on_slave(io_command, command_hash)
    end


    def run(io_command, {:lrem, key, value}) do
        Logger.info("LREM  #{value} in #{key}")
        command_hash = key
        run_on_slave(io_command, command_hash)
    end


    def run(_io_command, {:rpoplpush, key1, key2}) do
        Logger.info("RPOPLPUSH #{key1} #{key2}")

        command_hash = key1
        rpop_result = run_on_slave("RPOP #{key1} \n", command_hash)
        poped = Utils.parse_slave_response(rpop_result)
        IO.inspect("RPOP result: #{poped}")

        command_hash = key2
        lpush_result = run_on_slave("LPUSH #{key2} #{poped} \n", command_hash)
        IO.inspect("LPUSH result: #{lpush_result}")

        rpop_result
    end


    def run(io_command, {:ttl, key}) do
        command_hash = key
        run_on_slave(io_command, command_hash)
    end


    def run(io_command, {:expire, key, sec}) do
        Logger.info("EXPIRE #{key} in #{sec} seconds")
        command_hash = key
        run_on_slave(io_command, command_hash)
    end

    defp run_on_slave(io_command, _command_hash) do
        registry = SlaveRegistry.get_registry()

        [first_slave_name | _tail] = Map.get(registry, "slaves", [])
        [first_replica_socket | _tail] = Map.get(registry, @tag_replicas <> first_slave_name)


        Logger.info("EXECUTE #{io_command} on slave #{Kernel.inspect(first_replica_socket)}")
        :ok = :gen_tcp.send(first_replica_socket, io_command)

        {:ok, response_from_slave} = :gen_tcp.recv(first_replica_socket, @recv_length)
        Logger.info("Response from slave: #{response_from_slave}")
        response_from_slave
    end
end
