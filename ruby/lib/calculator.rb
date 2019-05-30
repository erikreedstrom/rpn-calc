# frozen_string_literal: true

require 'bigdecimal'

# An RPN calculator.
#
# Provides methods for calculating operations in RPN notation.
#
# An instance provides a single method, `process`, which takes
# either a numeric input, or an operator.
#
# Supports:
# - addition `+`
# - subtraction `-`
# - multiplication `*`
# - division `/`
#
# @example Add two numbers
#   calc = Calculator.new
#   calc.process('1')
#   calc.process('1')
#   calc.process('+')
#   # => '2'
#
class Calculator
  def initialize
    @stack = []
  end

  def process(input)
    # Guard against invalid input.
    raise(StandardError, 'Invalid input.') unless valid? input

    # Place number on stack
    return place(input) if numeric? input

    # Apply operation to last two input values
    operate(input)
  end

  private

  def place(numeric)
    @stack << BigDecimal(numeric)
    format(numeric)
  end

  def operate(input)
    raise(StandardError, 'At least 2 values are required.') unless @stack.size >= 2

    last = @stack.last(2)
    result = apply(input, *@stack.pop(2))
    if result.to_s.match? 'Infinity'
      @stack.concat last
      raise StandardError, 'Function returns Infinity.'
    end

    @stack << result
    format(result.to_f)
  end

  def apply(operator, a, b)
    a.public_send(operator, b)
  end

  def valid?(input)
    %r{^(?:[\+\-\*\/]|\-?\d+(?:.\d+)?)$}.match(input)
  end

  def numeric?(input)
    /^\-?\d+(?:.\d+)?$/.match(input)
  end

  def format(numeric)
    # Drop insignificant 0s
    numeric.to_i == numeric ? numeric.to_i.to_s : numeric.to_s
  end
end
