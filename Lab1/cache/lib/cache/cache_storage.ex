defmodule Cache.Storage do
    use Agent
    require Logger

    def start_link(initial_storage) do
        Agent.start_link(fn -> initial_storage end, name: __MODULE__)
    end

    def set(key, value) do
        Agent.update(__MODULE__, fn storage -> Map.put(storage, key, value) end)
    end

    def setnx(key, value) do
        Agent.update(__MODULE__, fn storage -> Map.put_new(storage, key, value) end)
    end

    def get(key) do
        Agent.get(__MODULE__, fn storage -> Map.get(storage, key, nil) end)
    end

    def mget(keys) do
        storage = get_storage()
        Enum.reduce(keys, [], fn key, list -> 
            value = Map.get(storage, key)
            [value | list]
        end)
    end

    def delete_key(key) do
        storage = get_storage()
        {deleted_value, new_map} = Map.pop(storage, key)
        update_storage(new_map)
        deleted_value
    end

    def delete_keys(keys) do
        Enum.reduce(keys, 0, fn key, deleted -> 
            if Map.has_key?(get_storage(), key) do
                {_deleted_value, new_map} = Map.pop(get_storage(), key)
                update_storage(new_map)
                deleted + 1
            end
        end)
    end

    defp update_storage(new_storage) do
        Agent.update(__MODULE__, fn _storage -> new_storage end)
    end

    defp get_storage() do
        Agent.get(__MODULE__, fn storage -> storage end)
    end
end