# frozen_string_literal: true

require 'rspec'
require 'calculator'

describe Calculator, '#process' do
  subject(:calc) { described_class.new }

  context 'invalid inputs' do
    it 'returns warning on invalid input' do
      expect { calc.process('%') }.to raise_error('Invalid input.')
    end

    it 'returns warning on operations with too few values' do
      calc.process('2')
      expect { calc.process('-') }.to raise_error('At least 2 values are required.')
    end

    it 'returns warning on division by 0' do
      calc.process('5')
      calc.process('0')
      expect { calc.process('/') }.to raise_error('Function returns Infinity.')
    end
  end

  context 'valid inputs' do
    describe 'standard arithmetic operators' do
      it 'supports addition' do
        expects = %w[5 8 13]
        %w[5 8 +].each_with_index do |x, i|
          expect(calc.process(x)).to eq(expects[i])
        end
      end

      it 'supports subtraction' do
        expects = %w[5 8 -3]
        %w[5 8 -].each_with_index do |x, i|
          expect(calc.process(x)).to eq(expects[i])
        end
      end

      it 'supports multiplication' do
        expects = %w[5 8 40]
        %w[5 8 *].each_with_index do |x, i|
          expect(calc.process(x)).to eq(expects[i])
        end
      end

      it 'supports division' do
        expects = %w[5 8 0.625]
        %w[5 8 /].each_with_index do |x, i|
          expect(calc.process(x)).to eq(expects[i])
        end
      end
    end

    describe 'negative and decimal numbers' do
      it 'supports negative numbers' do
        expects = %w[-5 -8 -13]
        %w[-5 -8 +].each_with_index do |x, i|
          expect(calc.process(x)).to eq(expects[i])
        end
      end

      it 'supports decimal numbers' do
        expects = %w[-0.5 -8 4]
        %w[-0.5 -8 *].each_with_index do |x, i|
          expect(calc.process(x)).to eq(expects[i])
        end
      end
    end

    describe 'number of operations' do
      it 'supports stacked operators' do
        expects = %w[2 9 3 12 24]
        %w[2 9 3 + *].each_with_index do |x, i|
          expect(calc.process(x)).to eq(expects[i])
        end
      end

      it 'supports chained operations' do
        expects = %w[20 13 7 2 3.5]
        %w[20 13 - 2 /].each_with_index do |x, i|
          expect(calc.process(x)).to eq(expects[i])
        end
      end
    end
  end
end
