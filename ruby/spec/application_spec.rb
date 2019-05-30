# frozen_string_literal: true

require 'rspec'
require 'application'
require_relative 'support/fake_io'

describe Application, '#process' do
  subject(:app) { described_class.new }

  describe '#run' do
    it 'prints a quit instruction' do
      output = FakeIO.each_input(['']) { app.run }
      expect(output).to eq("Type\e[0;33;49m `q` \e[0mto end the session.\n> Exiting.\n")
    end

    it 'quits on `q`' do
      output = FakeIO.each_input(['q']) { app.run }
      expect(output).to eq("Type\e[0;33;49m `q` \e[0mto end the session.\n> Exiting.\n")
    end

    it 'quits on EOF' do
      output = FakeIO.each_input([nil]) { app.run }
      expect(output).to eq("Type\e[0;33;49m `q` \e[0mto end the session.\n> Exiting.\n")
    end

    it 'prints validity warnings' do
      output = FakeIO.each_input(%w[s -]) { app.run }
      expected_output = "Type\e[0;33;49m `q` \e[0mto end the session.\n> \
\e[0;31;49m[error]\e[0m Invalid input.\n> \e[0;31;49m[error]\e[0m At least 2 values are required.\n> Exiting.\n"
      expect(output).to eq(expected_output)
    end

    it 'prints calculator returns' do
      output = FakeIO.each_input(%w[2 9 3 + *]) { app.run }
      expected_output = "Type\e[0;33;49m `q` \e[0mto end the session.\n> 2\n> 9\n> 3\n> 12\n> 24\n> Exiting.\n"
      expect(output).to eq(expected_output)
    end
  end
end
