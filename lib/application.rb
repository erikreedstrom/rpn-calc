require_relative 'calculator'

class Application
  def initialize(stdin = $stdin, stdout = $stdout)
    @stdin = stdin
    @stdout = stdout

    # Instantiate calculator
    @calc = Calculator.new
  end

  def run
    # Create REPL
    @stdout.puts 'Type `q` to end the session.'
    loop do
      # Print prompt
      @stdout.write '> '

      # Halt on EOF/EOT
      begin
        line = @stdin.gets
        (@stdout.write "\n" and break) unless line && !line.empty?
      rescue Interrupt
        @stdout.write "\n" and break
      end

      # Exit on `q` or process arg
      arg, *params = line.chomp
      case arg
        when 'q' then break
        else
          # Pass args to calc for processing and print return
          execute(arg)
      end
    end

    @stdout.puts 'Exiting.'
  end

  private

  def execute(arg)
    begin
      @stdout.puts @calc.process(arg) if arg
    rescue StandardError => error
      @stdout.write "#{error.message}\n"
    end
  end
end