defmodule AdventOfCode.CrossedWires do
  @moduledoc "Module for Day 3 of Advent of Code 2019"

  defmodule Wire do
    defstruct coordinates: [{0, 0}], steps: %{}, length: 0

    @type t :: %__MODULE__{
            coordinates: [{pos_integer, pos_integer}],
            # A map of steps to the first visit of each coordinate
            steps: map,
            # Total length of the wire
            length: pos_integer
          }

    @spec new() :: t()
    def new do
      struct(__MODULE__)
    end
  end

  @type instructions :: [String.t()]
  @type wire :: %Wire{coordinates: [{pos_integer, pos_integer}], steps: map, length: pos_integer}

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
    %{coordinates: coords_1} = traverse_wire(wire_1)
    %{coordinates: coords_2} = traverse_wire(wire_2)

    # Find all intersection points in list of coordinates
    [{min_x, min_y} | _] =
      coords_1
      |> get_intersections(coords_2)
      # Find closest intersection point to origin (`{0,0}`)
      |> Enum.sort(fn {x1, y1}, {x2, y2} ->
        abs(x1) <= abs(x2) && abs(y1) <= abs(y2)
      end)

    # Calculate Manhatten distance from closest intersection point (i.e. `x + y`)
    abs(min_x + min_y)
  end

  @doc """
  Calculates the number of steps each wire takes to reach each intersection;
  then chooses the intersection where the sum of both wires' steps is lowest.

  ## Examples

      iex> AdventOfCode.CrossedWires.fewest_steps(~w[R75 D30 R83 U83 L12 D49 R71 U7 L72], ~w[U62 R66 U55 R34 D71 R55 D58 R83])
      610
      iex> AdventOfCode.CrossedWires.fewest_steps(~w[R98 U47 R26 D63 R33 U87 L62 D20 R33 U53 R51], ~w[U98 R91 D20 R16 D67 R40 U7 R15 U6 R7])
      410
  """
  @spec fewest_steps(wire, wire) :: pos_integer
  def fewest_steps(wire_1, wire_2) do
    # Translate wire instructions into coordinates with steps
    %{coordinates: coords_1} = wire_1 = traverse_wire(wire_1)
    %{coordinates: coords_2} = wire_2 = traverse_wire(wire_2)

    coords_1
    |> get_intersections(coords_2)
    |> Enum.map(&(wire_1.steps[&1] + wire_2.steps[&1]))
    |> Enum.min()
  end

  defp traverse_wire(wire) do
    Enum.reduce(wire, Wire.new(), &parse_instruction/2)
  end

  defp parse_instruction(<<dir::utf8>> <> steps, %{coordinates: [{x, y} | _]} = wire) do
    1..String.to_integer(steps)
    |> Enum.reduce(wire, fn n, acc ->
      [dir]
      |> to_string()
      |> case do
        "U" -> {x, y + n}
        "D" -> {x, y - n}
        "R" -> {x + n, y}
        "L" -> {x - n, y}
      end
      |> (&%{
            acc
            | coordinates: [&1 | acc.coordinates],
              steps: Map.put_new(acc.steps, &1, acc.length + 1),
              length: acc.length + 1
          }).()
    end)
  end

  defp get_intersections(coords_1, coords_2) do
    coords_1
    |> coordinates_to_set()
    |> MapSet.intersection(coordinates_to_set(coords_2))
    |> MapSet.to_list()
  end

  defp coordinates_to_set(coordinates) do
    coordinates
    |> MapSet.new()
    |> MapSet.delete({0, 0})
  end
end
