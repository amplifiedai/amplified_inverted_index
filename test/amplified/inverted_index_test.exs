defmodule Amplified.InvertedIndexTest do
  use ExUnit.Case, async: true

  alias Amplified.InvertedIndex

  doctest InvertedIndex

  describe "to_text/1" do
    test "reconstructs text from inverted index" do
      index = %{
        "This" => [0],
        "paper" => [1],
        "presents" => [2],
        "a" => [3, 11],
        "novel" => [4],
        "flexible" => [5],
        "deep" => [6],
        "body" => [7],
        "thermometer" => [8],
        "utilizing" => [9],
        "the" => [10],
        "zero" => [12],
        "heat" => [13],
        "flux" => [14],
        "principle." => [15]
      }

      assert InvertedIndex.to_text(index) ==
               "This paper presents a novel flexible deep body thermometer utilizing the a zero heat flux principle."
    end

    test "returns nil for nil input" do
      assert InvertedIndex.to_text(nil) == nil
    end

    test "handles empty map" do
      assert InvertedIndex.to_text(%{}) == ""
    end

    test "handles single word" do
      assert InvertedIndex.to_text(%{"Hello" => [0]}) == "Hello"
    end

    test "handles words appearing at multiple positions" do
      index = %{"the" => [0, 2], "cat" => [1], "chased" => [3], "dog" => [4]}
      assert InvertedIndex.to_text(index) == "the cat the chased dog"
    end

    test "raises ArgumentError for invalid input" do
      assert_raise ArgumentError, ~r/expected a map or nil/, fn ->
        InvertedIndex.to_text(42)
      end

      assert_raise ArgumentError, ~r/expected a map or nil/, fn ->
        InvertedIndex.to_text("not a map")
      end
    end
  end

  describe "from_text/1" do
    test "converts text to inverted index" do
      assert InvertedIndex.from_text("Hello world") == %{"Hello" => [0], "world" => [1]}
    end

    test "groups repeated words" do
      assert InvertedIndex.from_text("the cat chased the dog") ==
               %{"cat" => [1], "chased" => [2], "dog" => [4], "the" => [0, 3]}
    end

    test "returns nil for nil input" do
      assert InvertedIndex.from_text(nil) == nil
    end

    test "handles empty string" do
      assert InvertedIndex.from_text("") == %{}
    end

    test "raises ArgumentError for invalid input" do
      assert_raise ArgumentError, ~r/expected a string or nil/, fn ->
        InvertedIndex.from_text(42)
      end

      assert_raise ArgumentError, ~r/expected a string or nil/, fn ->
        InvertedIndex.from_text(%{})
      end
    end

    test "roundtrips with to_text" do
      text = "This paper presents a novel flexible deep body thermometer"
      assert text |> InvertedIndex.from_text() |> InvertedIndex.to_text() == text
    end
  end
end
