# frozen_string_literal: true

class FakeIO
  attr_accessor :input, :output

  def initialize(input)
    @input = input
    @output = ''
  end

  def gets
    (line = @input.shift).nil? ? nil : line.to_s
  end

  def puts(string)
    @output += "#{string}\n"
  end

  def write(string)
    @output += string
  end

  def self.each_input(input)
    io = new(input)
    $stdin = io
    $stdout = io

    yield

    io.output
  ensure
    $stdin = STDIN
    $stdout = STDOUT
  end
end
