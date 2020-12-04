defmodule CacheMaster do
	use Application

	def start(_type, _args) do
		Cache.BaseSupervisor.run_as_master()
	end
end
