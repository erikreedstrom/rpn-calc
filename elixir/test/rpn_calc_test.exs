defmodule RPNCalcTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias RPNCalc.Calculator

  setup do
    Agent.update(Calculator, fn _ -> [] end)
  end

  describe "main/0" do
    test "prints a quit instruction" do
      assert capture_io("q", fn -> RPNCalc.main([]) end) ==
               "Type \e[33m`q`\e[0m to end the session.\n> Exiting.\n"
    end

    test "quits on `q`" do
      assert capture_io("q", fn -> RPNCalc.main([]) end) ==
               "Type \e[33m`q`\e[0m to end the session.\n> Exiting.\n"
    end

    test "quits on EOF" do
      assert capture_io("", fn -> RPNCalc.main([]) end) ==
               "Type \e[33m`q`\e[0m to end the session.\n> Exiting.\n"
    end

    test "prints validity warnings" do
      expected_output =
        "Type \e[33m`q`\e[0m to end the session.\n> \
\e[31m[error]\e[0m Invalid input.\n> \e[31m[error]\e[0m At least 2 values are required.\n> Exiting.\n"

      assert capture_io([input: Enum.join(~w(s -), "\n")], fn -> RPNCalc.main([]) end) ==
               expected_output
    end

    test "prints calculator returns" do
      expected_output =
        "Type \e[33m`q`\e[0m to end the session.\n> 2\n> 9\n> 3\n> 12\n> 24\n> Exiting.\n"

      assert capture_io([input: Enum.join(~w(2 9 3 + *), "\n")], fn -> RPNCalc.main([]) end) ==
               expected_output
    end
  end
end
