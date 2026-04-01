defmodule Amplified.InvertedIndex do
  @moduledoc """
  Converts between plain text and inverted index format.

  An inverted index maps each unique word to the list of positions where it
  appears in the original text:

      %{"Despite" => [0], "growing" => [1], "interest" => [2], "in" => [3, 57]}

  This format is used by [OpenAlex](https://openalex.org) to represent
  scholarly abstracts. This module converts between that representation and
  plain text strings.

  ## Examples

      iex> index = %{"Hello" => [0], "world" => [1]}
      iex> Amplified.InvertedIndex.to_text(index)
      "Hello world"

      iex> Amplified.InvertedIndex.from_text("Hello world")
      %{"Hello" => [0], "world" => [1]}

  """

  @doc """
  Converts an inverted index map to plain text.

  Returns `nil` if the input is `nil`.

  ## Examples

      iex> Amplified.InvertedIndex.to_text(%{"Hello" => [0], "world" => [1]})
      "Hello world"

      iex> Amplified.InvertedIndex.to_text(%{"the" => [0, 3], "cat" => [1], "chased" => [2], "dog" => [4]})
      "the cat chased the dog"

      iex> Amplified.InvertedIndex.to_text(nil)
      nil

  """
  @spec to_text(map() | nil) :: String.t() | nil
  def to_text(nil), do: nil

  def to_text(inverted_index) when is_map(inverted_index) do
    inverted_index
    |> Stream.flat_map(fn {word, positions} -> Enum.map(positions, &{&1, word}) end)
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.map_join(" ", &elem(&1, 1))
  end

  def to_text(other),
    do: raise(ArgumentError, "expected a map or nil, got: #{inspect(other)}")

  @doc """
  Converts plain text to an inverted index map.

  Returns `nil` if the input is `nil`.

  ## Examples

      iex> Amplified.InvertedIndex.from_text("Hello world")
      %{"Hello" => [0], "world" => [1]}

      iex> Amplified.InvertedIndex.from_text("the cat chased the dog")
      %{"cat" => [1], "chased" => [2], "dog" => [4], "the" => [0, 3]}

      iex> Amplified.InvertedIndex.from_text(nil)
      nil

  """
  @spec from_text(String.t() | nil) :: map() | nil
  def from_text(nil), do: nil

  def from_text(text) when is_binary(text) do
    text
    |> String.split()
    |> Stream.with_index()
    |> Enum.reduce(%{}, fn {word, index}, acc ->
      Map.update(acc, word, [index], &(&1 ++ [index]))
    end)
  end

  def from_text(other),
    do: raise(ArgumentError, "expected a string or nil, got: #{inspect(other)}")
end
