defmodule Cache.BaseSupervisor do
    use Supervisor, restart: :permanent

    def init(children) do
        Supervisor.init(children, strategy: :one_for_one)
    end

    def run_as_master() do
        Supervisor.start_link(__MODULE__, [
            {Cache.Storage.Extra, %{}},
            {Cache.Storage, %{}},
            {Cache.SlaveRegistry, %{}},
            {Task.Supervisor, name: ClientCommandListener.Supervisor},
            {Cache.ClientListener, []},
            {Cache.NewSlaveListener, []},
            {Cache.LiveManager, []}
        ], name: Cache.BaseSupervisor)
    end

    def run_as_slave() do
        Supervisor.start_link(__MODULE__, [
            {Cache.Storage.Extra, %{}},
            {Cache.Storage, %{}},
            {Cache.SlaveRegistry, %{}},
            {Task.Supervisor, name: MasterCommandListener.Supervisor},
            Cache.ConnectionToMaster,
            {Cache.LiveManager, []}
        ], name: Cache.BaseSupervisor)
    end
end
