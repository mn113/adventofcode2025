defmodule Day07 do
  @start "S"
  @splitter "^"

  # Read the diagram, extract coords of start "S" and splitters "^"
  defp read_input do
    File.read!(Path.expand("../inputs/input07.txt"))
    |> String.split("\n")
    |> Enum.with_index
    |> Enum.map(fn {line, y} ->
      start_x = line |> String.graphemes |> Enum.find_index(&(&1 == @start))
      xlimit = String.length(line)

      splitters = line
      |> String.graphemes
      |> Enum.with_index
      |> Enum.filter(&(elem(&1, 0) == @splitter))
      |> Enum.map(&({y, elem(&1, 1)}))

      {{y, start_x}, xlimit, splitters}
    end)
    |> Enum.reject(fn {st, _xlim, spl} -> elem(st, 1) == nil and spl == [] end)
    |> then(fn [hd | rest] ->
      splitters = Enum.map(rest, &(elem(&1, 2))) |> List.flatten
      {
        # start coords
        elem(hd, 0),
        # splitters[]
        splitters,
        # ylimit (final y coord)
        Enum.max(Enum.map(splitters, &(elem(&1, 0)))) + 1,
        # xlimit
        elem(hd, 1)
      }
    end)
  end

  @doc """
  Count the used splitters
  """
  def part1 do
    Day07.part2
  end

  @doc """
  Count all possible beam ends in parallel worlds
  """
  def part2 do
    {start, splitters, ylimit, xlimit} = read_input()

    splitters_used = 0
    beam_count = 1
    first_row = (0..xlimit)
    |> Enum.map(fn _ -> 0 end)
    |> List.update_at(elem(start, 1), fn _ -> 1 end)

    Enum.reduce(2..ylimit, [splitters_used, beam_count, first_row, nil], fn y, [splits1, count1, row1, _] ->
      Enum.reduce(0..xlimit, [splits1, count1, row1, nil], fn x, [splits2, count2, row2, _] ->
        local_beam_count = Enum.at(row2, x)
        if {y, x} in splitters and local_beam_count > 0 do
          row3 = List.update_at(row2, x-1, &(&1 + local_beam_count))
          row4 = List.update_at(row3, x+1, &(&1 + local_beam_count))
          row5 = List.update_at(row4, x, fn _ -> 0 end)
          [splits2 + 1, count2 + local_beam_count, row5, :split]
        else
          [splits2, count2, row2, :miss]
        end
      end)
    end)
    |> then(fn res ->
      IO.inspect(Enum.at(res, 0), label: "P1")
      IO.inspect(Enum.at(res, 1), label: "P2")
    end)
  end
end

# P1: 1499
# P2: 24743903847942
