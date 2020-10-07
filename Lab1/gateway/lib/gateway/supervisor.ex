defmodule Gateway.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: Cache)
  end

  def init(_) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Gateway.Router, options: [port: 4000]},
      {Redix, {"redis://redix.example.com", [name: :redix, port: 6397]}}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
