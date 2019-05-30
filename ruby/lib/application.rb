# frozen_string_literal: true

require_relative 'calculator'

require 'colorize'

# Provides command line interface for RPN calculator.
class Application
  def initialize(stdin = $stdin, stdout = $stdout)
    @stdin = stdin
    @stdout = stdout

    # Instantiate calculator
    @calc = Calculator.new
  end

  def run
    begin
      # Create REPL
      @stdout.puts 'Type' + ' `q` '.yellow + 'to end the session.'
      loop do
        # Print prompt
        @stdout.write '> '
        # Halt on EOF/EOT
        break if interpret(@stdin.gets) == :exit
      end
    rescue Interrupt
      @stdout.puts "\n"
    end

    @stdout.puts 'Exiting.'
  end

  private

  def execute(arg)
    @stdout.puts @calc.process(arg) if arg
  rescue StandardError => e
    @stdout.write '[error]'.red + " #{e.message}\n"
  end

  def interpret(line)
    return :exit unless line && !line.empty?

    arg, *_params = line.chomp
    case arg
    # Exit on `q` or process arg
    when 'q' then :exit
    # Pass args to calc for processing and print return
    else execute(arg)
    end
  end
end
