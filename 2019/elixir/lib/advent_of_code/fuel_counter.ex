defmodule AdventOfCode.FuelCounter do
  @moduledoc false

  @type mass :: pos_integer

  @doc """
  Fuel required to launch a given module is based on its mass. Specifically,
  to find the fuel required for a module, take its mass, divide by three,
  round down, and subtract 2.

  Fuel itself requires fuel just like a module - take its mass, divide by
  three, round down, and subtract 2. However, that fuel also requires fuel,
  and that fuel requires fuel, and so on. Any mass that would require
  negative fuel should instead be treated as if it requires zero fuel; the
  remaining mass, if any, is instead handled by wishing really hard, which
  has no mass and is outside the scope of this calculation.

  ## Examples

      iex> AdventOfCode.FuelCounter.call(12)
      2
      iex> AdventOfCode.FuelCounter.call(14)
      2
      iex> AdventOfCode.FuelCounter.call(1969)
      966
      iex> AdventOfCode.FuelCounter.call(100756)
      50346
  """
  @spec call(mass) :: mass
  def call(mass) when is_integer(mass) and mass > 0 do
    case Integer.floor_div(mass, 3) - 2 do
      fuel_mass when fuel_mass > 0 ->
        call(fuel_mass) + fuel_mass

      _ ->
        0
    end
  end

  def call(_), do: 0
end
