defmodule AdventOfCode.CrossedWires do
  @type wire :: [String.t()]

  @doc """
  ## Examples

      iex> AdventOfCode.CrossedWires.manhatten_distance(~w[R75 D30 R83 U83 L12 D49 R71 U7 L72], ~w[U62 R66 U55 R34 D71 R55 D58 R83])
      159
      iex> AdventOfCode.CrossedWires.manhatten_distance(~w[R98 U47 R26 D63 R33 U87 L62 D20 R33 U53 R51], ~w[U98 R91 D20 R16 D67 R40 U7 R15 U6 R7])
      135
  """
  @spec manhatten_distance(wire, wire) :: pos_integer
  def manhatten_distance(wire_1, wire_2) do
    # Translate wire instructions into coordinates
    coords_1 = translate_coordinates(wire_1)
    coords_2 = translate_coordinates(wire_2)

    # Find all intersection points in list of coordinates
    [{min_x, min_y} | _] =
      coords_1
      |> MapSet.intersection(coords_2)
      |> MapSet.to_list()
      # Find closest intersection point to origin (`{0,0}`)
      |> Enum.sort(fn {x1, y1}, {x2, y2} ->
        abs(x1) <= abs(x2) && abs(y1) <= abs(y2)
      end)

    # Calculate Manhatten distance from closest intersection point (i.e. `x + y`)
    abs(min_x + min_y)
  end

  defp translate_coordinates(instructions) do
    instructions
    |> Enum.reduce([{0, 0}], &find_coordinates/2)
    |> MapSet.new()
    |> MapSet.delete({0, 0})
  end

  defp find_coordinates(<<dir::utf8>> <> steps, [{x, y} | _] = coords) do
    1..String.to_integer(steps)
    |> Enum.reduce(coords, fn n, acc ->
      case to_string([dir]) do
        "U" -> [{x, y + n} | acc]
        "D" -> [{x, y - n} | acc]
        "R" -> [{x + n, y} | acc]
        "L" -> [{x - n, y} | acc]
      end
    end)
  end
end
