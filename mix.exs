defmodule Taxjar.Mixfile do
  use Mix.Project

  def project do
    [
      app: :taxjar,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: "A client library for use of the TaxJar API.",
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
      {:httpoison, "~> 0.13"},
      {:poison, "~> 3.0"},
      {:ex_doc, ">= 0.0.0", only: :dev},
    ]
  end

  defp package do
    [
      maintainers: ["ChrisYammine"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/ChrisYammine/taxjar-elixir"}
    ]
  end
end
