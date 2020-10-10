defmodule Cache.BaseSupervisor do
    use Supervisor

    @cache_port Application.get_env(:cache_port, :port, 6666) 

    def start_link do
        Supervisor.start_link(__MODULE__, [], name: CacheSupervisor)
    end

    def init(_) do
        children = [
            {Task.Supervisor, name: Cache.ConnectionSupervisor},
            Supervisor.child_spec(
                {Task, fn -> Cache.ConnectionListener.accept(@cache_port) end}, restart: :permanent
            )
        ]

        Supervisor.init(children, strategy: :one_for_one)
    end
end