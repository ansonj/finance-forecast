class FinParser
  attr_accessor :input

  def initialize(file_name)
    @input = File.readlines(file_name) unless file_name.nil?
  end

  def input_events
    []
  end

  def starting_amount
    @input.each do |line|
      matches = /start with (\d+(\.\d\d)?)/.match line
      amount = matches[1]
      return amount.to_f unless amount.nil?
    end
    0
  end
end
