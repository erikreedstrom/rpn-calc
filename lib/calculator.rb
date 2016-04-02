require 'bigdecimal'

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
    @stack << BigDecimal.new(numeric)
    format(numeric)
  end

  def operate(input)
    raise(StandardError, 'At least 2 values are required.') unless @stack.size >= 2

    last = @stack.last(2)
    result = apply(input, *@stack.pop(2))
    if result.to_s == 'Infinity'
      @stack.concat last
      raise StandardError, 'Function returns Infinity.'
    end

    @stack << result
    format(result.to_f)
  end

  def apply(operator, a, b)
    a.public_send(operator, b);
  end

  def valid?(input)
    /^(?:[\+\-\*\/]|\-?\d+(?:.\d+)?)$/.match(input)
  end

  def numeric?(input)
    /^\-?\d+(?:.\d+)?$/.match(input)
  end

  def format(numeric)
    # Drop insignificant 0s
    numeric.to_i === numeric ? numeric.to_i.to_s : numeric.to_s
  end

end