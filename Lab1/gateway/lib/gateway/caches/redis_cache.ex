defmodule Gateway.Cache.RCache do
    def start_link do
        Redix.start_link(host: "redis", port: 6379, name: :redix)
    end

    def command(cmd) do
        Redix.command!(:redix, cmd)
    end

   def child_spec(_args) do
        %{
            id: __MODULE__,
            type: :worker,
            start: {__MODULE__, :start_link, []}
        }
   end
end