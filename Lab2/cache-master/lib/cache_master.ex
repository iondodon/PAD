defmodule CacheMaster do
	use Application

	def start(_type, _args) do
		is_default_master = System.get_env("DEFAULT_MASTER")
		if is_default_master == "true" do
			Cache.BaseSupervisor.run_as_master()
		else
			Cache.BaseSupervisor.run_as_slave()
		end
	end
end
