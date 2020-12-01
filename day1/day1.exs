defmodule Day1 do
  def combine(enum, 2) do
    for x <- enum, y <- enum, x != y, do: {x, y}
  end

  def combine(enum, 3) do
    for x <- enum, y <- enum, z <- enum, x != y and y !== z, do: {x, y, z}
  end

  def prep() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  def part_one() do
    {x, y} =
      prep()
      |> combine(2)
      |> Enum.find(nil, fn {x, y} -> x + y === 2020 end)

    IO.inspect({x, y, x * y})
  end

  def part_two() do
    {x, y, z} =
      prep()
      |> combine(3)
      |> Enum.find(nil, fn {x, y, z} -> x + y + z === 2020 end)

    IO.inspect({x, y, z, x * y * z})
  end
end
