defmodule AdventOfCode.Intcode do
  @moduledoc false

  @type instructions :: [Integer.t()]

  @doc """
  An Intcode program is a list of integers separated by commas (like
  1,0,0,3,99). To run one, start by looking at the first integer (called
  position 0). Here, you will find an opcode - either 1, 2, or 99. The opcode
  indicates what to do; for example, 99 means that the program is finished
  and should immediately halt. Encountering an unknown opcode means something
  went wrong.

  Opcode 1 adds together numbers read from two positions and stores the result
  in a third position. The three integers immediately after the opcode tell you
  these three positions - the first two indicate the positions from which you
  should read the input values, and the third indicates the position at which
  the output should be stored.

  For example, if your Intcode computer encounters 1,10,20,30, it should read
  the values at positions 10 and 20, add those values, and then overwrite the
  value at position 30 with their sum.

  Opcode 2 works exactly like opcode 1, except it multiplies the two inputs
  instead of adding them. Again, the three integers after the opcode indicate
  where the inputs and outputs are, not their values.

  Once you're done processing an opcode, move to the next one by stepping
  forward 4 positions.

  ## Examples

      iex> AdventOfCode.Intcode.call([1,0,0,0,99])
      [2,0,0,0,99]
      iex> AdventOfCode.Intcode.call([2,3,0,3,99])
      [2,3,0,6,99]
      iex> AdventOfCode.Intcode.call([2,4,4,5,99,0])
      [2,4,4,5,99,9801]
      iex> AdventOfCode.Intcode.call([1,1,1,4,99,5,6,0,99])
      [30,1,1,4,2,5,6,0,99]
  """
  @spec call(instructions) :: instructions
  def call(instructions) when is_list(instructions) do
    process(instructions, 0)
  end

  @spec find_noun_and_verb(instructions, pos_integer) :: {pos_integer, pos_integer} | no_return
  def find_noun_and_verb(instructions, result, noun \\ 0, verb \\ 0)

  def find_noun_and_verb(_instructions, result, 100, _) do
    raise "Could not find a noun or verb for #{result}"
  end

  def find_noun_and_verb(instructions, result, noun, 100) do
    find_noun_and_verb(instructions, result, noun + 1, 0)
  end

  def find_noun_and_verb(instructions, result, noun, verb)
      when is_list(instructions) and is_integer(result) and result > 0 do
    instructions
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
    |> call()
    |> Enum.at(0)
    |> case do
      ^result ->
        {noun, verb}

      _ ->
        find_noun_and_verb(instructions, result, noun, verb + 1)
    end
  end

  defp process(instructions, current_pos) do
    instructions
    |> Enum.slice(current_pos, 4)
    |> process_chunk(instructions)
    |> case do
      :halt ->
        instructions

      instructions ->
        process(instructions, current_pos + 4)
    end
  end

  defp process_chunk([99 | _], _instructions), do: :halt

  defp process_chunk([1, op_pos_1, op_pos_2, res_pos], instructions) do
    operand_1 = Enum.at(instructions, op_pos_1)
    operand_2 = Enum.at(instructions, op_pos_2)

    List.replace_at(instructions, res_pos, operand_1 + operand_2)
  end

  defp process_chunk([2, op_pos_1, op_pos_2, res_pos], instructions) do
    operand_1 = Enum.at(instructions, op_pos_1)
    operand_2 = Enum.at(instructions, op_pos_2)

    List.replace_at(instructions, res_pos, operand_1 * operand_2)
  end
end
