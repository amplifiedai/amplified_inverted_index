# Amplified.InvertedIndex

Convert between plain text and inverted index format.

An inverted index maps each unique word to the list of positions where it
appears in the original text. This format is used by
[OpenAlex](https://openalex.org) to represent scholarly abstracts.

## Installation

Add `amplified_inverted_index` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:amplified_inverted_index, "~> 0.1.0"}
  ]
end
```

## Usage

### Reconstructing text from an inverted index

```elixir
index = %{
  "This" => [0],
  "paper" => [1],
  "presents" => [2],
  "a" => [3],
  "novel" => [4],
  "approach" => [5]
}

Amplified.InvertedIndex.to_text(index)
# => "This paper presents a novel approach"
```

### Building an inverted index from text

```elixir
Amplified.InvertedIndex.from_text("the cat chased the dog")
# => %{"cat" => [1], "chased" => [2], "dog" => [4], "the" => [0, 3]}
```

Both functions accept `nil` and return `nil`, making them safe to use in
pipelines with optional data.

## Licence

MIT — see [LICENCE.md](LICENCE.md).
