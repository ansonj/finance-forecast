require 'spec_helper'

describe Generator do
  it 'initializes properly' do
    events = [SalaryEvent.new('Testing', 345, '1-2016')]
    save_start = 99.99
    gen = Generator.new(events, save_start)
    gen.input_events.must_equal events
    gen.savings_starting_balance.must_equal save_start
  end

  describe 'output_months' do
    it 'needs to be tested'
  end
end
