defmodule LoadBalancer do
    alias Gateway.Cache.RCache
    @doc """
        Checks if there is any available service registered in the cache
    """
    def any_available? do
        RCache.command(["LLEN", "services"]) > 0
    end
    
    @doc """
        Returns next service address
    """
    def next do
        RCache.command(["RPOPLPUSH", "services", "services"])
    end

end