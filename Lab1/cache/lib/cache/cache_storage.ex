defmodule Cache.Storage do
    @doc """
    Every value is stored as a string
    """

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
            list ++ [value]
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
                Kernel.inspect(deleted + 1)
            end
        end)
    end

    def increment(key) do
        value = Agent.get(__MODULE__, fn storage -> storage[key] end)
        if value != :nil do
            case Integer.parse(value) do
                {value, _} -> 
                    value = value + 1
                    set(key, value)
                    Kernel.inspect(value)
                :error -> :error
            end
        else
            value
        end
    end

    defp update_storage(new_storage) do
        Agent.update(__MODULE__, fn _storage -> new_storage end)
    end

    defp get_storage() do
        Agent.get(__MODULE__, fn storage -> storage end)
    end
end