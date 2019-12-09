defmodule AdventOfCode.SecureContainer do
  @moduledoc """
  This module is for the solution for Day 4.

  You arrive at the Venus fuel depot only to discover it's protected by a
  password. The Elves had written the password on a sticky note, but someone
  threw it out.

  However, they do remember a few key facts about the password:

    - It is a six-digit number.
    - The value is within the range given in your puzzle input.
    - Two adjacent digits are the same (like 22 in 122345).
    - Going from left to right, the digits never decrease; they only ever
      increase or stay the same (like 111123 or 135679).

  Other than the range rule, the following are true:

    - 111111 does not meet these criteria (the repeated 11is part of a larger group).
    - 223450 does not meet these criteria (decreasing pair of digits 50).
    - 123789 does not meet these criteria (no double).
    - 112233 meets these criteria because the digits never decrease and all repeated digits are exactly two digits long.
    - 123444 no longer meets the criteria (the repeated 44 is part of a larger group of 444).
    - 111122 meets the criteria (even though 1 is repeated more than twice, it still contains a double 22).
  """

  @doc """
  Detects passwords from given input. Input is assumed to be a hypen-delineated
  string of passwords.

  ## Examples
   
      iex> AdventOfCode.SecureContainer.password_count("111111-111113")
      0
      iex> AdventOfCode.SecureContainer.password_count("156788-156799")
      2
  """
  @spec password_count(String.t()) :: pos_integer
  def password_count(input) when is_binary(input) do
    [start_number, end_number] =
      input
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)

    start_number..end_number
    |> Enum.filter(&is_password?/1)
    |> length()
  end

  @doc """
  Returns true if given password meets criteria.

  ## Examples
   
      iex> AdventOfCode.SecureContainer.is_password?(111)
      false
      iex> AdventOfCode.SecureContainer.is_password?(111111)
      false
      iex> AdventOfCode.SecureContainer.is_password?(223450)
      false
      iex> AdventOfCode.SecureContainer.is_password?(111123)
      false
      iex> AdventOfCode.SecureContainer.is_password?(123789)
      false
      iex> AdventOfCode.SecureContainer.is_password?(135679)
      false
      iex> AdventOfCode.SecureContainer.is_password?(112233)
      true
      iex> AdventOfCode.SecureContainer.is_password?(123444)
      false
      iex> AdventOfCode.SecureContainer.is_password?(111122)
      true
  """
  @spec is_password?(pos_integer) :: boolean
  def is_password?(password) when is_integer(password) do
    password
    |> Integer.digits()
    |> check_digits()
  end

  defp check_digits([first_digit | rest] = digits) when length(digits) == 6 do
    rest
    |> Enum.reduce_while({[first_digit], %{}}, &check_digit/2)
    |> case do
      {digits, repeated_digits} when is_list(digits) and is_map(repeated_digits) ->
        repeated_digits
        |> Map.values()
        |> Enum.any?()

      _ ->
        false
    end
  end

  defp check_digits(_digits), do: false

  # Used in a reduce_while. Hence the return tuple containing either :continue
  # or :halt.
  defp check_digit(digit, {[prev_digit | _rest] = digits, repeated_digits})
       when prev_digit == digit do
    repeated_digits = Map.update(repeated_digits, digit, true, fn _val -> false end)

    {:cont, {[digit | digits], repeated_digits}}
  end

  defp check_digit(digit, {[prev_digit | _rest], _repeated_digits}) when prev_digit > digit do
    {:halt, false}
  end

  defp check_digit(digit, {digits, repeated_digits}) do
    {:cont, {[digit | digits], repeated_digits}}
  end
end
