defmodule Cache.ConnectionToMaster do
	alias Cache.Storage
	alias Cache.SlaveRegistry

	require Logger
	require IEx

	@master_host Application.get_env(:cache_slave, :master_host, 'cache-slave1-replica1')
	@master_port Application.get_env(:cache_slave, :master_port, 6667)

	@delay 1000
	@recv_length 0

	def connect() do
		opts = [:binary, :inet, active: false, packet: :line]
		case :gen_tcp.connect(@master_host, @master_port, opts) do
			{:ok, master_socket} ->
				hand_shake(master_socket)
			{:error, _reason} -> connect()
		end
	end

	defp hand_shake(master_socket) do
		#IEx.pry

		:ok = :timer.sleep(@delay)

		# "\n" is a MUST, it won't work without it, it won't be received
		io_data = %{
			"slave_name" => System.get_env("SLAVE_NAME"),
			"slave_host" => System.get_env("HOST")
		}
		{:ok, io_data} = Poison.encode(io_data)
		:ok = :gen_tcp.send(master_socket, io_data <> "\n")

		{:ok, io_data} = :gen_tcp.recv(master_socket, @recv_length)

		io_data = String.replace(io_data, "\n", "")
		{:ok, io_data_map} = Poison.decode(io_data)

		master_host = io_data_map["master_host"]
		Storage.set("master_host", master_host)
		IO.inspect(Storage.get("master_host"))

		slave_registry = io_data_map["slave_registry"]
		SlaveRegistry.set_registry(slave_registry)

		io_state = io_data_map["state"]
		io_state = String.replace(io_state, "\n", "")

		"(map) " <> state = io_state
		{:ok, state} = Poison.decode(state)
		Logger.info("Received initial state from siblings")
		Storage.update_storage(state)
		IO.inspect(state)

		Logger.info("Successfully registered to master")

		{:ok, _pid} = Task.Supervisor.start_child(
			MasterCommandListener.Supervisor,
			fn -> Cache.MasterCommandListener.serve(master_socket) end,
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
