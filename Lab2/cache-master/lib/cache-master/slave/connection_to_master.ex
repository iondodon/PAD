defmodule Cache.ConnectionToMaster do
	alias Cache.Storage
	alias Cache.SlaveRegistry

	require Logger

	@master_host Application.get_env(:cache_slave, :master_host, 'cache-slave1-replica1')
	@master_port Application.get_env(:cache_slave, :master_port, 6667)

	@delay 1000
	@recv_length 0

	defp is_next_master? do
		slave_registry = SlaveRegistry.get_registry()
		slave_hosts = Map.get(slave_registry, "slave_hosts", :nil)
		if slave_hosts == :nil or Enum.empty?(slave_hosts) do
			true
		else
			next_master_host = List.first(slave_hosts)
			if next_master_host == System.get_env("HOST") do
				true
			else
				false
			end
		end
	end

	defp get_master_host() do
		slave_registry = Cache.SlaveRegistry.get_registry()
		slave_hosts = Map.get(slave_registry, "slave_hosts", [])

		master_host = if slave_hosts != :nil or (slave_hosts != :nil and Enum.empty?(slave_hosts)) do
			'cache-slave1-replica1'
		else
			[master_host, _rest] = slave_hosts
			String.to_charlist(master_host)
		end

		master_host
	end

	defp restart_as_master() do
		IO.inspect("Should be restarted as master")
	end

	def connect() do
		master_host = get_master_host()
		IO.inspect(master_host)
		Logger.info(master_host)

		opts = [:binary, :inet, active: false, packet: :line]
		case :gen_tcp.connect(master_host, @master_port, opts) do
			{:ok, master_socket} ->
				hand_shake(master_socket)
			{:error, reason} ->
				Logger.error(reason)
				if is_next_master?() do restart_as_master() else connect() end
		end
	end

	defp hand_shake(master_socket) do
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
		SlaveRegistry.set_master_host(master_host)

		slave_hosts = io_data_map["slave_hosts"]
		SlaveRegistry.set_slave_hosts(slave_hosts)

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
			[restart: :temporary]
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
