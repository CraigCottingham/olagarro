defmodule Olagarro.MixProject do
  use Mix.Project

  def project do
    [
      app: :olagarro,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: ["lib", "spec/factories"],
      start_permanent: Mix.env() == :prod,
      preferred_cli_env: [espec: :test],
      deps: deps(),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:credo, "~> 0.10.2", only: [:dev, :test], runtime: false},
      {:espec, "~> 1.6", only: :test},
      {:faker, "~> 0.11.0", only: :test},
      {:ex_machina, "~> 2.2"},
      {:mix_test_watch, "~> 0.9.0", only: :dev, runtime: false},
      {:nimble_parsec, "~> 0.4.0"}
    ]
  end
end
