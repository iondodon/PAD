defmodule Cache.Command do
    require Logger
    alias Cache.SlaveRegistry
    alias Cache.Storage.Extra
    alias Cache.Storage

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

    def run(_io_command, {:set, key, value}) do
        Logger.info("SET #{key} to #{value}")
        Storage.set(key, value)
    end

    def run(_io_command, {:setnx, key, value}) do
        Logger.info("SET  #{key} to #{value}, if not exists")
        Storage.setnx(key, value)
    end

    def run(_io_command, {:get, key}) do
        Logger.info("GET #{key}")
        Storage.get(key)
    end

    def run(_io_command, {:mget, keys}) do
        keys_str = Enum.reduce(keys, "", fn key, keys_str -> keys_str <> key <> " " end)
        Logger.info("MGET #{keys_str}")
        values = Storage.mget(keys)
        IO.inspect(values)
        Enum.reduce(values, "", fn value, str -> str <> value <> " " end)
    end

    @doc """
    Deletes multiple keys
    """
    def run(_io_command, {:del, keys}) when is_list(keys) do
        keys_str = Enum.reduce(keys, "", fn key, keys_str -> keys_str <> key <> " " end)
        Logger.info("DELETE #{keys_str}")
        Storage.delete_keys(keys)
    end

    def run(_io_command, {:del, key}) do
        Logger.info("DELETE #{key}")
        Storage.delete_key(key)
    end

    def run(_io_command, {:incr, key}) do
        Logger.info("INCR #{key}")
        Storage.increment(key)
    end

    def run(io_command, {:lpush, key, values}) do
        Logger.info("LPUSH into #{key} values #{Kernel.inspect(values)}")
        run_on_slave(io_command)
    end

    def run(_io_command, {:llen, key}) do
        Logger.info("LLEN #{key}")
        Storage.llen(key)
    end

    def run(_io_command, {:lrem, key, value}) do
        Logger.info("LREM  #{value} in #{key}")
        Storage.lrem(key, value)
    end

    def run(_io_command, {:rpoplpush, key1, key2}) do
        Logger.info("RPOPLPUSH #{key1} #{key2}")
        Storage.rpoplpush(key1, key2)
    end

    def run(_io_command, {:ttl, key}) do
        ttl = Extra.get_ttl("ttl#" <> key)
        if ttl != :nil do
            ttl - System.os_time(:second)
        else
            ttl
        end
    end

    def run(_io_command, {:expire, key, sec}) do
        Logger.info("EXPIRE #{key} in #{sec} seconds")
        {sec, _} = Integer.parse(sec)
        ttl = System.os_time(:second) + sec
        Extra.set_key_ttl("ttl#" <> key, ttl)
    end

    defp run_on_slave(io_command) do
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
