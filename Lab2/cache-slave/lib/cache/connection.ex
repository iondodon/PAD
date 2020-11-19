defmodule Cache.Connection do
    require Logger

	@master_ip Application.get_env(:cache, :master_ip, 'cache-master')
	@master_port Application.get_env(:cache, :master_port, 6666)

	def connect() do
		opts = [:binary, :inet, active: false, packet: :line]
		{:ok, socket} = :gen_tcp.connect(@master_ip, @master_port, opts)
		:gen_tcp.send(socket, "PUSHSLAVE\n")
		Logger.info("Connected to master")

		{:ok, _pid} = Task.Supervisor.start_child(
			Cache.MessageListener.Supervisor,
			fn -> Cache.MessageListener.serve(socket) end,
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
