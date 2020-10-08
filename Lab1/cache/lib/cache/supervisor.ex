defmodule Cache.Supervisor do
    use Supervisor

    def start_link do
        Supervisor.start_link(__MODULE__, [], name: CacheSupervisor)
    end

    def init(_) do
        children = [
            Cache.ConnectionListener
        ]

        Supervisor.init(children, strategy: :one_for_one)
    end
end