defmodule Day05 do
  # Read input as lines
  # First part is list of valid ranges
  # Second part is list of ids
  defp read_input do
    [s1, s2] = File.read!(Path.expand("../inputs/input05.txt"))
    |> String.split("\n\n")

    ranges = s1
    |> String.split("\n")
    |> Enum.map(fn line ->
      Regex.run(~r/^(\d+)-(\d+)/, line)
      |> Enum.drop(1)
      |> Enum.map(&String.to_integer/1)
    end)

    ids = s2
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)

    [ranges, ids]
  end

  # Reduce the known ranges to eliminate overlaps
  # (may require multiple passes to do it perfectly)
  defp reduce_ranges(ranges) do
    Enum.reduce(ranges, [], fn range, acc ->
      [range_first, range_last] = range
      if length(acc) == 0 do
        [range]
      else
        Enum.concat(acc,
          Enum.reduce(acc, [], fn acc_range, _acc2 ->
            [acc_range_first, acc_range_last] = acc_range
            cond do
              # if range entirely within acc_range, discard
              range_first >= acc_range_first and range_last <= acc_range_last ->
                []
              # if range fully without acc_range, append
              range_first < acc_range_first and range_last > acc_range_last ->
                [range]
              # if range apart, append
              range_last < acc_range_first or range_first > acc_range_last ->
                [range]
              # if partial overlapping at front, shrink range, append
              range_first < acc_range_first and range_last <= acc_range_last ->
                [[range_first, acc_range_first - 1]]
              # if partial overlapping at back, shrink range, append
              range_first >= acc_range_first and range_last > acc_range_last ->
                [[acc_range_last + 1, range_last]]
              true ->
                raise "Range error for #{range}"
                []
            end
          end)
        )
      end
    end)
  end

  @doc """
  Count the fresh IDs listed
  """
  def part1 do
    [ranges, ids] = read_input()
    ids
    |> Enum.filter(fn id ->
      Enum.any?(ranges, fn [first, last] ->
        first <= id and id <= last
      end)
    end)
    |> Enum.count
    |> IO.inspect(label: "P1")
  end

  @doc """
  Count all possible fresh IDs in the ranges
    # ovrlap cases:
    #       [acc_range]
    # 1      [range]
    # 2   [ r a n g e ]
    # 5 [r]
    # 6                 [r]
    # 3 [range]
    # 4           [range]
  """
  def part2 do
    [ranges, _ids] = read_input()
    ranges
    # 3 rounds of the following is enough, 2 doesn't reduce the ranges enough
    |> reduce_ranges
    |> Enum.sort
    |> Enum.dedup_by(&(Enum.at(&1, 1))) # if same end element, keep lowest start element

    |> reduce_ranges
    |> Enum.sort
    |> Enum.dedup_by(&(Enum.at(&1, 1))) # if same end element, keep lowest start element

    |> reduce_ranges
    |> Enum.sort
    |> Enum.dedup_by(&(Enum.at(&1, 1))) # if same end element, keep lowest start element

    |> Enum.map(&(Enum.at(&1, 1) + 1 - Enum.at(&1, 0)))
    |> Enum.sum
    |> IO.inspect(label: "P2")
  end
end

# P1: 770
# P2: 357674099117260
