defmodule RPNCalc.Calculator do
  @moduledoc """
  An RPN calculator.

  Provides methods for calculating operations in RPN notation.

  An instance provides a single method, `process`, which takes
  either a numeric input, or an operator.

  Supports:
  - addition `+`
  - subtraction `-`
  - multiplication `*`
  - division `/`

  Example: Add two numbers

    RPNCalc.Calculator.process("1")
    RPNCalc.Calculator.process("1")
    RPNCalc.Calculator.process("+")
    # => "2"
  """
  use Agent

  def start_link(stack), do: Agent.start_link(fn -> stack end, name: __MODULE__)

  def process(input) do
    with {:valid?, true} <- {:valid?, valid?(input)} do
      if numeric?(input) do
        # Place number on stack
        place(input)
      else
        # Apply operation to last two input values
        operate(input)
      end
    else
      # Guard against invalid input.
      {:valid?, false} -> raise "Invalid input."
    end
  end

  ## PRIVATE FUNCTIONS

  defp apply_op("+", a, b), do: Decimal.add(a, b)
  defp apply_op("-", a, b), do: Decimal.sub(a, b)
  defp apply_op("*", a, b), do: Decimal.mult(a, b)
  defp apply_op("/", a, b), do: Decimal.div(a, b)

  defp numeric?(input), do: String.match?(input, ~r/^\-?\d+(?:.\d+)?$/)

  defp place(numeric) do
    decimal = Decimal.new(numeric)
    Agent.update(__MODULE__, &List.insert_at(&1, -1, decimal))
    Decimal.to_string(decimal, :normal)
  end

  defp operate(input) do
    stack = Agent.get(__MODULE__, & &1)
    if length(stack) < 2, do: raise("At least 2 values are required.")

    {stack, [a, b]} = Enum.split(stack, -2)

    result =
      case {input, Decimal.cmp(0, b)} do
        {"/", :eq} ->
          raise "Function returns Infinity."

        _ ->
          apply_op(input, a, b)
      end

    Agent.update(__MODULE__, fn _ -> List.insert_at(stack, -1, result) end)

    Decimal.to_string(result, :normal)
  end

  defp valid?(input), do: String.match?(input, ~r/^(?:[\+\-\*\/]|\-?\d+(?:.\d+)?)$/)
end
