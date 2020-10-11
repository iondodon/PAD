defmodule Cache.Command do
    require Logger
    alias Cache.Storage

    def parse(line) do
        case String.split(line) do
            ["SET", key, value] -> {:ok, {:set, key, value}}
            ["SETNX", key, value] -> {:ok, {:setnx, key, value}}
            ["GET", key] -> {:ok, {:get, key}}
            ["MGET" | keys] -> {:ok, {:mget, keys}}
            ["DEL", key] -> {:ok, {:del, key}}
            ["DEL" | keys] -> {:ok, {:del, keys}}
            ["EXPIRE", key, sec] -> {:ok, {:expire, key, sec}}
            _ -> {:error, :unknown_command}
          end
    end

    # Command execution

    def run(command)

    def run({:set, key, value}) do
        Logger.info("SET #{key} to #{value}")
        Storage.set(key, value)
    end

    def run({:setnx, key, value}) do
        Logger.info("SET  #{key} to #{value}, if not exists")
        Storage.setnx(key, value)
    end

    def run({:get, key}) do
        Logger.info("GET #{key}")
        Storage.get(key)
    end

    def run({:mget, keys}) do
        keys_str = Enum.reduce(keys, "", fn key, keys_str -> keys_str <> key <> " " end)
        Logger.info("MGET #{keys_str}")
        values = Storage.mget(keys)
        IO.inspect(values)
        Enum.reduce(values, "", fn value, str -> str <> value <> " " end)
    end

    @doc """
    Deletes multiple keys
    """
    def run({:del, keys}) when is_list(keys) do
        keys_str = Enum.reduce(keys, "", fn key, keys_str -> keys_str <> key <> " " end)
        Logger.info("DELETE #{keys_str}")
        Storage.delete_keys(keys)
    end

    def run({:del, key}) do
        Logger.info("DELETE #{key}")
        Storage.delete_key(key)
    end

    def run({:expire, key, sec}) do
        Logger.info("EXPIRE #{key} in {sec} seconds")
        
    end
end