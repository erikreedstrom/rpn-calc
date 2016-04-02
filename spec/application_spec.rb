require 'rspec'
require 'application'
require_relative 'support/fake_io'

describe Application, '#process' do

  subject(:app) { described_class.new }

  describe '#run' do

    it 'prints a quit instruction' do
      output = FakeIO.each_input(['']) { app.run }
      expect(output).to eq("Type `q` to end the session.\n> \nExiting.\n")
    end

    it 'quits on `q`' do
      output = FakeIO.each_input(['q']) { app.run }
      expect(output).to eq("Type `q` to end the session.\n> Exiting.\n")
    end

    it 'quits on EOF' do
      output = FakeIO.each_input([nil]) { app.run }
      expect(output).to eq("Type `q` to end the session.\n> \nExiting.\n")
    end

    it 'prints validity warnings' do
      output = FakeIO.each_input(%w(s -)) { app.run }
      expected_output = "Type `q` to end the session.\n> Invalid input.\n> At least 2 values are required.\n> \nExiting.\n"
      expect(output).to eq(expected_output)
    end

    it 'prints calculator returns' do
      output = FakeIO.each_input(%w(2 9 3 + *)) { app.run }
      expected_output = "Type `q` to end the session.\n> 2\n> 9\n> 3\n> 12\n> 24\n> \nExiting.\n"
      expect(output).to eq(expected_output)
    end

  end

end