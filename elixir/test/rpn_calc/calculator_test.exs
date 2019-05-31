defmodule RPNCalculator.CalculatorTest do
  use ExUnit.Case

  alias RPNCalc.Calculator

  setup do
    Agent.update(Calculator, fn _ -> [] end)
  end

  describe "process/1 with invalid inputs" do
    test "raises error on invalid input" do
      assert_raise RuntimeError, "Invalid input.", fn ->
        Calculator.process("%")
      end
    end

    test "raises error on operations with too few values" do
      Calculator.process("2")

      assert_raise RuntimeError, "At least 2 values are required.", fn ->
        Calculator.process("-")
      end
    end

    test "raises error on division by 0" do
      Calculator.process("5")
      Calculator.process("0")

      assert_raise RuntimeError, "Function returns Infinity.", fn ->
        Calculator.process("/")
      end
    end
  end

  describe "process/1" do
    # standard arithmetic operators
    test "supports addition" do
      asserts = ~w(5 8 13)

      ~w(5 8 +)
      |> Enum.with_index()
      |> Enum.each(fn {x, i} ->
        assert Calculator.process(x) == Enum.at(asserts, i)
      end)
    end

    test "supports subtraction" do
      asserts = ~w(5 8 -3)

      ~w(5 8 -)
      |> Enum.with_index()
      |> Enum.each(fn {x, i} ->
        assert Calculator.process(x) == Enum.at(asserts, i)
      end)
    end

    test "supports multiplication" do
      asserts = ~w(5 8 40)

      ~w(5 8 *)
      |> Enum.with_index()
      |> Enum.each(fn {x, i} ->
        assert Calculator.process(x) == Enum.at(asserts, i)
      end)
    end

    test "supports division" do
      asserts = ~w(5 8 0.625)

      ~w(5 8 /)
      |> Enum.with_index()
      |> Enum.each(fn {x, i} ->
        assert Calculator.process(x) == Enum.at(asserts, i)
      end)
    end

    # negative and decimal numbers

    test "supports negative numbers" do
      asserts = ~w(-5 -8 -13)

      ~w(-5 -8 +)
      |> Enum.with_index()
      |> Enum.each(fn {x, i} ->
        assert Calculator.process(x) == Enum.at(asserts, i)
      end)
    end

    test "supports decimal numbers" do
      asserts = ~w(-0.5 -8 4.0)

      ~w(-0.5 -8 *)
      |> Enum.with_index()
      |> Enum.each(fn {x, i} ->
        assert Calculator.process(x) == Enum.at(asserts, i)
      end)
    end

    # number of operations

    test "supports stacked operators" do
      asserts = ~w(2 9 3 12 24)

      ~w(2 9 3 + *)
      |> Enum.with_index()
      |> Enum.each(fn {x, i} ->
        assert Calculator.process(x) == Enum.at(asserts, i)
      end)
    end

    test "supports chained operations" do
      asserts = ~w(20 13 7 2 3.5)

      ~w(20 13 - 2 /)
      |> Enum.with_index()
      |> Enum.each(fn {x, i} ->
        assert Calculator.process(x) == Enum.at(asserts, i)
      end)
    end
  end
end
