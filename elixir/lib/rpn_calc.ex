defmodule RPNCalc do
  @moduledoc """
  Provides command line interface for RPN calculator.
  """

  def main(_args) do
    {:ok, _} = Application.ensure_all_started(:rpn_calc)
    IO.puts("Type #{IO.ANSI.yellow()}`q`#{IO.ANSI.reset()} to end the session.")

    loop()
  end

  ## PRIVATE FUNCTIONS

  defp loop do
    with arg when arg != :eof <- IO.gets("> "),
         arg = arg |> String.trim(),
         arg when arg != "q" <- arg,
         value when value != :ok <- execute(arg) do
      IO.puts(value)
      loop()
    else
      exits when exits in [:eof, "q"] -> IO.puts("Exiting.")
      :ok -> loop()
    end
  end

  defp execute(arg) do
    RPNCalc.Calculator.process(arg)
  catch
    _type, %{message: error} -> IO.puts("#{IO.ANSI.red()}[error]#{IO.ANSI.reset()} #{error}")
  end
end
