require 'spec_helper'

def parser_with_input(input)
  parser = FinParser.new(nil)
  parser.input = input
  parser
end

describe FinParser do
  describe 'initialize' do
    it 'copies the file contents into @input' do
      test_file = 'input.txt'
      File.exist?(test_file).must_equal true

      parser = FinParser.new(test_file)
      parser.input.wont_be_nil
    end

    it 'allows nil input' do
      parser = FinParser.new(nil)
      parser.input.must_be_nil
    end
  end

  describe 'input_events' do
    describe 'SalaryEvent' do
      it 'parses increases correctly' do
        parser = parser_with_input ['salary increase 50000 1-2017 Alice base salary']
        events = parser.input_events

        events.count.must_equal 1
        events.first.must_equal SalaryEvent.new('Alice base salary', 50000.0, '1-2017')
      end

      it 'parses decreases correctly' do
        parser = parser_with_input ['salary decrease 50000 5-2017 Bob quits to study math']
        events = parser.input_events

        events.count.must_equal 1
        events.first.must_equal SalaryEvent.new('Bob quits to study math', -50000.0, '5-2017')
      end
    end

    describe 'BillsEvent' do
      it 'parses increases correctly' do
        parser = parser_with_input ['bills increase 300 4-2017 New car payment']
        events = parser.input_events

        events.count.must_equal 1
        events.first.must_equal BillsEvent.new('New car payment', 300.0, '4-2017')
      end

      it 'parses decreases correctly' do
        parser = parser_with_input ['bills decrease 300 4-2020 Car paid off']
        events = parser.input_events

        events.count.must_equal 1
        events.first.must_equal BillsEvent.new('Car paid off', -300.0, '4-2020')
      end
    end

    describe 'ExtraEvent' do
      it 'parses extra income correctly' do
        parser = parser_with_input ['extra income 1000 3-2017 Alice gets a bonus']
        events = parser.input_events

        events.count.must_equal 1
        events.first.must_equal ExtraEvent.new('Alice gets a bonus', 1000.0, '3-2017')
      end

      it 'parses extra expense correctly' do
        parser = parser_with_input ['extra expense 500 4-2017 Car repair']
        events = parser.input_events

        events.count.must_equal 1
        events.first.must_equal ExtraEvent.new('Car repair', -500.0, '4-2017')
      end
    end
  end

  describe 'starting_amount' do
    it 'reports a value' do
      parser = FinParser.new(nil)
      parser.input = ['start with 149']
      parser.starting_amount.must_equal 149
    end

    it 'reports the first value' do
      parser = FinParser.new(nil)
      parser.input = ["start with 1\nstart with 2\n"]
      parser.starting_amount.must_equal 1
    end

    it 'handles decimals' do
      parser = FinParser.new(nil)
      parser.input = ['start with 42.35']
      parser.starting_amount.must_equal 42.35
    end

    it 'reports zero if no amount given' do
      parser = FinParser.new(nil)
      parser.input = []
      parser.starting_amount.must_equal 0
    end
  end
end
