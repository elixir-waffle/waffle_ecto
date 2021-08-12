defmodule Waffle.Ecto.Mixfile do
  use Mix.Project

  @version "0.0.11"

  def project do
    [app: :waffle_ecto,
     version: @version,
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     deps: deps(),
     docs: docs(),

     # Hex
     description: description(),
     package: package()]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp description do
    """
    An integration with Waffle and Ecto.
    """
  end

  defp package do
    [maintainers: ["Boris Kuznetsov"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/elixir-waffle/waffle_ecto"},
     files: ~w(mix.exs README.md CHANGELOG.md lib)]
  end

  defp docs do
    [
      main: "Waffle.Ecto",
      extras: ["documentation/examples/filepath-with-id.md"]
    ]
  end

  defp deps do
    [
      {:waffle, "~> 1.0"},
      {:ecto, "~> 3.0"},
      {:mock, "~> 0.3", only: :test},
      {:ex_doc, ">= 0.23.0", only: :dev},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end
end
