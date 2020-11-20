defmodule Cache.ClientListener do
    use Task, restart: :permanent
    require Logger

    @gateway_for_client Application.get_env(:cache_master, :gateway_for_client, 6666)

    def start_link(_args) do
      Task.start_link(__MODULE__, :run, [])
    end

    def run() do
		listen(@gateway_for_client)
    end

    def listen(port) do
		opts = [:binary, packet: :line, active: false, reuseaddr: true]
        {:ok, socket} = :gen_tcp.listen(port, opts)
        Logger.info "Listening clients on port #{port}"
        loop_acceptor(socket)
    end

    defp loop_acceptor(socket) do
        {:ok, client} = :gen_tcp.accept(socket)
        Logger.info("New client connected #{Kernel.inspect client}")

		{:ok, pid} = Task.Supervisor.start_child(
			CommandListener.Supervisor,
			fn -> Cache.CommandListener.serve(client) end,
			[restart: :permanent]
        )
        :ok = :gen_tcp.controlling_process(client, pid)

        loop_acceptor(socket)
    end
end
