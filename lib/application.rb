require_relative 'calculator'

class Application
  def initialize(stdin = $stdin, stdout = $stdout)
    @stdin = stdin
    @stdout = stdout
  end

  def run
    # Instantiate calculator
    calc = Calculator.new

    # Create REPL
    @stdout.puts 'Type `q` to end the session.'
    loop do
      # Print prompt
      @stdout.write '> '

      # Halt on EOF/EOT
      line = @stdin.gets
      (@stdout.write "\n" and break) unless line && !line.empty?

      # Exit on `q` or process arg
      arg, *params = line.chomp
      case arg
        when 'q' then break
        else
          # Pass args to calc for processing and print return
          @stdout.puts calc.process(arg) if arg
      end
    end

    @stdout.puts 'Exiting.'
  end

end