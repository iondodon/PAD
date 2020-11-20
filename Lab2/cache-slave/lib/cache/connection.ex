defmodule Cache.Connection do
    require Logger

	@master_ip Application.get_env(:cache_slave, :master_ip, 'cache-master')
	@master_port Application.get_env(:caccache_slavehe, :master_port, 6667)

	def connect() do
		opts = [:binary, :inet, active: false, packet: :line]
		{:ok, master_socket} = :gen_tcp.connect(@master_ip, @master_port, opts)
		Logger.info("Connected to master")

		{:ok, _pid} = Task.Supervisor.start_child(
			CommandListener.Supervisor,
			fn -> Cache.CommandListener.serve(master_socket) end,
			[restart: :permanent]
		)
	end

	def child_spec(_opts) do
		%{
		 	id: __MODULE__,
		 	start: {__MODULE__, :connect, []},
			type: :worker,
			restart: :permanent
		}
	end

end
