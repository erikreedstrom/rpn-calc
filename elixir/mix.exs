defmodule RPNCalc.MixProject do
  use Mix.Project

  def project do
    [
      app: :rpn_calc,
      escript: escript(),
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.html": :test,
        "coveralls.json": :test,
        test: :test
      ],
      dialyzer: [plt_add_apps: [:mix], ignore_warnings: "dialyzer.ignore_warnings"]
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {RPNCalc.Application, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp escript do
    [main_module: RPNCalc]
  end

  defp deps do
    [
      {:decimal, "~> 1.0"},
      {:dialyxir, "~> 1.0.0-rc.3", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end
end
