defmodule Day3 do
  @tree "#"
  @slope_offset 3

  def prep() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
  end

  def is_int(n), do: ceil(n) === floor(n)

  def count_trees_hit(slope_offset \\ @slope_offset) do
    fn {row, index}, acc ->
      index_to_check = rem(index * slope_offset, length(row))

      case Enum.at(row, index_to_check) do
        @tree -> acc + 1
        _ -> acc
      end
    end
  end

  def part_one() do
    prep()
    |> Enum.with_index()
    |> Enum.reduce(0, count_trees_hit())
  end

  def part_two() do
    slope_offsets = [
      {1, 1},
      {3, 1},
      {5, 1},
      {7, 1},
      {1, 2}
    ]

    slope_offsets
    |> Enum.map(fn {right, down} ->
      prep()
      |> Enum.take_every(down)
      |> Enum.with_index()
      |> Enum.reduce(0, count_trees_hit(right))
    end)
    |> Enum.reduce(1, fn x, acc -> x * acc end)
  end
end
