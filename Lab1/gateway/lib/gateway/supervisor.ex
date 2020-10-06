defmodule Gateway.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Gateway.Router, options: [port: 4000]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
