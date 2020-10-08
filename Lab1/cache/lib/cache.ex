defmodule Cache do
  use Application

  def start(_type, _args) do
    Cache.Supervisor.start_link()
  end
end
