defmodule AdventOfCode do
  @moduledoc """
  Documentation for AdventOfCode 2019.
  """

  alias AdventOfCode.FuelCounter

  @doc """
  The Elves quickly load you into a spacecraft and prepare to launch.

  At the first Go / No Go poll, every Elf is Go until the Fuel Counter-Upper.
  They haven't determined the amount of fuel required yet.

  The Fuel Counter-Upper needs to know the total fuel requirement. To find
  it, individually calculate the fuel needed for the mass of each module
  (your puzzle input), then add together all the fuel values.
  """
  def total_fuel do
    "day_1.txt"
    |> puzzle_input_stream()
    |> Stream.map(&String.to_integer/1)
    |> Stream.map(&FuelCounter.call/1)
    |> Enum.sum()
  end

  @doc "Builds a File Stream for a given puzzle input filename."
  @spec puzzle_input_stream(String.t()) :: Stream.t()
  def puzzle_input_stream(path) do
    path
    |> puzzle_input_path()
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
  end

  @doc "Builds a file path for a puzzle input found in the `priv/` directory."
  @spec puzzle_input_path(String.t()) :: String.t()
  def puzzle_input_path(path) when is_binary(path) do
    :advent_of_code
    |> :code.priv_dir()
    |> Path.join("puzzle_inputs/#{path}")
  end
end
