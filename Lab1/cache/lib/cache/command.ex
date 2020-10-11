defmodule Cache.Command do
    require Logger
    alias Cache.Storage

    def parse(line) do
        case String.split(line) do
            ["SET", key, value] -> {:ok, {:set, key, value}}
            ["GET", key] -> {:ok, {:get, key}}
            _ -> {:error, :unknown_command}
          end
    end

    # Command execution

    def run(command)

    def run({:set, key, value}) do
        Logger.info("SET #{key} to #{value}")
        Storage.set(key, value)
    end

    def run({:get, key}) do
        Logger.info("GET #{key}")
        Storage.get(key)
    end
end