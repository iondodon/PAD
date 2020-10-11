defmodule Cache.Storage do
    use Agent
    require Logger
  
    def start_link(initial_storage) do
      Agent.start_link(fn -> initial_storage end, name: __MODULE__)
    end
  
    def set(key, value) do
      Agent.update(__MODULE__, &Map.put(&1, key, value))
    end

    def get(key) do
      Agent.get(__MODULE__, &Map.get(&1, key))
    end

    def delete(key) do
        Agent.get_and_update(__MODULE__, &Map.pop(&1, key))
    end
  end