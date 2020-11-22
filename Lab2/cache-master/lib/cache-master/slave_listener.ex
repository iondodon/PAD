defmodule Cache.SlaveListener do
	use Task, restart: :permanent
	require Logger
	alias Cache.Storage

	@port_for_slave Application.get_env(:cache_master, :port_for_slave, 6667)
	@recv_length 0

	def start_link(_args) do
		Task.start_link(__MODULE__, :run, [])
	end

	def run() do
		listen(@port_for_slave)
	end

	def listen(port) do
		opts = [:binary, packet: :line, active: false, reuseaddr: true]
		{:ok, socket} = :gen_tcp.listen(port, opts)
		Logger.info "Listening slaves on port #{port}"
		loop_acceptor(socket)
	end

	defp loop_acceptor(socket) do
		{:ok, slave} = :gen_tcp.accept(socket)
		Logger.info("New slave connected #{Kernel.inspect slave}")

		Task.async(fn -> register_slave(slave) end)

		loop_acceptor(socket)
	end

	defp register_slave(slave) do
		Logger.info("PUSHSLAVE #{Kernel.inspect(slave)}")
		{:ok, iodata} = :gen_tcp.recv(slave, @recv_length)
		{:ok, reg_data} = Poison.decode(iodata)
		IO.inspect(reg_data)
		Storage.push_slave(slave)
	end
end
