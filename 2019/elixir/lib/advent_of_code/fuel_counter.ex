defmodule AdventOfCode.FuelCounter do
  @doc """
  Fuel required to launch a given module is based on its mass. Specifically,
  to find the fuel required for a module, take its mass, divide by three,
  round down, and subtract 2.

  ## Examples

      iex> AdventOfCode.FuelCounter.call(12)
      2
      iex> AdventOfCode.FuelCounter.call(14)
      2
      iex> AdventOfCode.FuelCounter.call(1969)
      654
      iex> AdventOfCode.FuelCounter.call(100756)
      33583
  """
  @spec call(mass :: pos_integer) :: pos_integer
  def call(mass) when is_integer(mass) and mass > 0 do
    Integer.floor_div(mass, 3) - 2
  end
end
