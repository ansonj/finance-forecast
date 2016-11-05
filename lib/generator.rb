class Generator
  attr_reader :input_events, :savings_starting_balance

  def initialize(events, start = 0)
    @input_events = events
    @savings_starting_balance = start
  end

  def output_months
    []
  end
end
