require './lib/input_event.rb'

class FinParser
  attr_accessor :input

  def initialize(file_name)
    @input = File.readlines(file_name) unless file_name.nil?
  end

  def input_events
    @input.map { |l| event_for_line l }.reject { |e| e.nil? }
  end

  private def event_for_line(line)
    return salary_event_for_line line if line.start_with? 'salary'
    nil
  end

  private def salary_event_for_line(line)
    r = /salary (increase) (\d+(\.\d\d)?) (\d\d?-\d{4}) (.*?$)/
    match = r.match(line)
    return nil if match.nil?
    # direction = match[1]
    amount = match[2].to_f
    date = match[4]
    name = match[5]
    SalaryEvent.new(name, amount, date)
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
