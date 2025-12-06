defmodule Day06 do
  # Read input as lines
  defp read_input do
    File.read!(Path.expand("../inputs/input06.txt"))
    |> String.split("\n")
    |> Enum.take(5)
  end

  defp transpose_grid(grid) do
    for x <- 0..(length(Enum.at(grid, 0)) - 1), y <- 0..(length(grid) - 1) do
      Enum.at(Enum.at(grid, y), x)
    end
    |> Enum.chunk_every(length(grid))
  end

  # Add up or multiply up a list of numeric strings, which begins with the operator
  defp process_line(line) do
    [op | numstrs] = line
    case op do
      "+" -> Enum.sum(Enum.map(numstrs, &String.to_integer/1))
      "*" -> Enum.product(Enum.map(numstrs, &String.to_integer/1))
      "**" -> Enum.product(Enum.map(numstrs, &String.to_integer/1))
      _ -> raise "Invalid operator [#{op}]"
    end
  end

  defp process_set(set) do
    op = set |> Enum.at(0) |> elem(0)
    nums = Enum.map(set, &(elem(&1, 1)))
    case op do
      "+" -> Enum.sum(nums)
      "*" -> Enum.product(nums)
      _ -> raise "Invalid operator [#{op}]"
    end
  end

  defp is_only_spaces?(line), do: Enum.dedup(line) == [" "]

  @doc """
  Sum the result of each column.
  Columns are separated by 1+ spaces
  The result of each column is its numbers operated on by the operator in the final row.
  """
  def part1 do
    read_input()
    |> Enum.map(&String.split/1)
    |> Enum.reverse
    |> transpose_grid
    |> Enum.map(&process_line/1)
    |> Enum.sum
    |> IO.inspect(label: "P1")
  end

  @doc """
  Sum the result of each column.
  Every char is a column.
  The result of each column is its numbers operated on by the operator in the final row.
  """
  def part2 do
    read_input()
    |> Enum.map(&String.graphemes/1)
    |> Enum.reverse
    |> transpose_grid
    |> Enum.reject(&is_only_spaces?/1)
    |> Enum.map(fn line ->
      [op | numstrs] = line
      {op, numstrs |> Enum.reverse |> Enum.join("") |> String.trim |> String.to_integer}
    end)
    |> Enum.chunk_by(&(elem(&1, 0) != " "))
    |> Enum.chunk_every(2)
    |> Enum.map(&List.flatten/1)
    |> Enum.map(&process_set/1)
    |> Enum.sum
    |> IO.inspect(label: "P2")
  end
end

# P1: 5060053676136