defmodule Cache.ConnectionListener do
    use Task, restart: :permanent
    require Logger

	@master_ip Application.get_env(:cache, :master_ip, {127, 0, 0, 1})
	@master_port Application.get_env(:cache, :master_port, 6666)
	@recv_length 0


    def start_link(_args) do
      Task.start_link(__MODULE__, :run, [])
    end

    def run() do
      connect()
    end


	def connect() do
		opts = [:binary, :inet, active: false, packet: :line]
        {:ok, socket} = :gen_tcp.connect(@master_ip, @master_port, opts)
        Logger.info("Connected to slave")
        loop_receive(socket)
    end

    defp loop_receive(socket) do
		{:ok, packet} = :gen_tcp.recv(socket, @recv_length)
		IO.inspect(packet)
        loop_receive(socket)
    end
end
