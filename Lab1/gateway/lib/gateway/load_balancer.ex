defmodule LoadBalancer do
    alias Gateway.Cache.ECache
    @doc """
        Checks if there is any available service registered in the cache
    """
    def any_available? do
        ECache.command("LLEN services") > 0
    end
    
    @doc """
        Returns next service address
    """
    def next do
        ECache.command("RPOPLPUSH services services")
    end

end