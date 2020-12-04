defmodule Day4 do
  @required_fields ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

  defp validate_required_keys(row) do
    Enum.all?(
      @required_fields,
      fn field -> Enum.any?(row, &String.starts_with?(&1, field)) end
    )
  end

  defp prep() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&String.split(&1, ["\n", " "]))
  end

  def part_one() do
    prep()
    |> Enum.map(&validate_required_keys/1)
    |> Enum.count(&(&1 === true))
  end

  defp convert_to_map(list) do
    list
    |> Enum.map(&String.split(&1, ":"))
    |> Map.new(fn [key, value] -> {key, value} end)
  end

  defp validate_row(%{
         "byr" => byr,
         "iyr" => iyr,
         "eyr" => eyr,
         "hgt" => hgt,
         "hcl" => hcl,
         "ecl" => ecl,
         "pid" => pid
       }) do
    Enum.all?(
      [
        Validator.byr(byr),
        Validator.iyr(iyr),
        Validator.eyr(eyr),
        Validator.hgt(hgt),
        Validator.hcl(hcl),
        Validator.ecl(ecl),
        Validator.pid(pid)
      ],
      &(&1 === true)
    )
  end

  def part_two() do
    prep()
    |> Enum.filter(&validate_required_keys/1)
    |> Enum.map(&convert_to_map/1)
    |> Enum.map(&validate_row/1)
    |> Enum.count(&(&1 === true))
  end
end

defmodule Validator do
  @eye_colors ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
  @hgt_regex ~r/(\d*)([a-z]{2})/
  @hcl_regex ~r/#[0-9a-f]{6}/
  @pid_regex ~r/\d{9}/

  defp int_factory(value, validation_fn) do
    try do
      String.to_integer(value) |> validation_fn.()
    rescue
      _ in ArgumentError -> false
    end
  end

  def byr(v), do: int_factory(v, fn val -> val >= 1920 and val <= 2002 end)
  def iyr(v), do: int_factory(v, fn val -> val >= 2010 and val <= 2020 end)
  def eyr(v), do: int_factory(v, fn val -> val >= 2020 and val <= 2030 end)

  def hgt(v) do
    try do
      [height_str, unit] = Regex.run(@hgt_regex, v, capture: :all_but_first)
      height = String.to_integer(height_str)

      case unit do
        "in" -> height >= 59 and height < 76
        "cm" -> height >= 150 and height <= 193
        _ -> false
      end
    rescue
      _ -> false
    end
  end

  def hcl(v), do: Regex.match?(@hcl_regex, v)
  def ecl(v), do: Enum.member?(@eye_colors, v)
  def pid(v), do: Regex.match?(@pid_regex, v)
end
