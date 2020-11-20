defmodule Cache.SlaveListener do
	use Task, restart: :permanent
	require Logger
	alias Cache.Storage

	@port Application.get_env(:cache, :slave_port, 6667)

	def start_link(_args) do
		Task.start_link(__MODULE__, :run, [])
	end

	def run() do
		accept(@port)
	end

	def accept(port) do
		opts = [:binary, packet: :line, active: false, reuseaddr: true]
		{:ok, socket} = :gen_tcp.listen(port, opts)
		Logger.info "Listening slaves on port #{port}"
		loop_acceptor(socket)
	end

	defp loop_acceptor(socket) do
		{:ok, slave} = :gen_tcp.accept(socket)
		Logger.info("New slave connected #{Kernel.inspect slave}")
		register_slave(slave)

		loop_acceptor(socket)
	end

	defp register_slave(slave) do
		Logger.info("PUSHSLAVE #{Kernel.inspect(slave)}")
		Storage.push_slave(slave)
	end
end
