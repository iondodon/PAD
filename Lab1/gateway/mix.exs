defmodule Gateway.MixProject do
  use Mix.Project

  def project do
    [
      app: :gateway,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Gateway, []},
      env: [
        redis_host: "localhost",
        redis_port: 6379,
        gateway_port: 4000,
        failures_limit: 3
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:plug_cowboy, "~> 2.3.0"},
      {:httpoison, "~> 1.7"},
      {:jason, "~> 1.2.2"},
      {:redix, "~> 1.0"}
    ]
  end
end
