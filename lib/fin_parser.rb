class FinParser
  attr_reader :input

  def initialize(file_name)
    @input = File.readlines(file_name) unless file_name.nil?
  end

  def input_events
    []
  end

  def starting_amount
    0
  end
end
