defmodule Amplified.InvertedIndex.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/amplifiedai/amplified_inverted_index"

  def project do
    [
      app: :amplified_inverted_index,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs(),
      name: "Amplified.InvertedIndex",
      description: "Convert between plain text and inverted index format",
      source_url: @source_url
    ]
  end

  def application do
    [
      extra_applications: []
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.34", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs do
    [
      main: "Amplified.InvertedIndex",
      source_url: @source_url,
      source_ref: "v#{@version}"
    ]
  end
end
