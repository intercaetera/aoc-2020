defmodule Day2 do
  def prep_line(line) do
    [range, character, password] = String.split(line)
    [min, max] = String.split(range, "-")
    letter = String.first(character)

    %{
      min: String.to_integer(min),
      max: String.to_integer(max),
      letter: letter,
      password: password
    }
  end

  def prep() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&prep_line/1)
  end

  defp between?(num, min, max), do: num >= min and num <= max

  def is_password_valid(%{min: min, max: max, letter: letter, password: password}) do
    password
    |> String.graphemes()
    |> Enum.count(&(&1 == letter))
    |> between?(min, max)
  end

  def part_one() do
    prep()
    |> Enum.map(&is_password_valid/1)
    |> Enum.count(&(&1 === true))
  end

  defp xor(a, b), do: (a or b) and not (a and b)

  defp xor_fn(enum, fn1, fn2) do
    a = fn1.(enum)
    b = fn2.(enum)
    xor(a, b)
  end

  defp is_at?(string, position, character) do
    String.at(string, position - 1) === character
  end

  def is_second_password_valid(%{min: min, max: max, letter: letter, password: password}) do
    password
    |> xor_fn(
      fn password -> is_at?(password, min, letter) end,
      fn password -> is_at?(password, max, letter) end
    )
  end

  def part_two() do
    prep()
    |> Enum.map(&is_second_password_valid/1)
    |> Enum.count(&(&1 === true))
  end
end
