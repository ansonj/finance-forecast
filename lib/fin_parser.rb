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
    return bills_event_for_line line if line.start_with? 'bills'
    return extra_event_for_line line if line.start_with? 'extra'
    return save_spend_event_for_line line if line.start_with? 'spending event'
    nil
  end

  private def salary_event_for_line(line)
    r = /salary ((in|de)crease) (\d+(\.\d\d)?) (\d\d?-\d{4}) (.*?$)/
    match = r.match(line)
    return nil if match.nil?
    direction = match[1]
    amount = match[3].to_f
    amount *= -1.0 if direction == 'decrease'
    date = match[5]
    name = match[6]
    SalaryEvent.new(name, amount, date)
  end

  private def bills_event_for_line(line)
    r = /bills ((in|de)crease) (\d+(\.\d\d)?) (\d\d?-\d{4}) (.*?$)/
    match = r.match(line)
    return nil if match.nil?
    direction = match[1]
    amount = match[3].to_f
    amount *= -1.0 if direction == 'decrease'
    date = match[5]
    name = match[6]
    BillsEvent.new(name, amount, date)
  end

  private def extra_event_for_line(line)
    r = /extra (income|expense) (\d+(\.\d\d)?) (\d\d?-\d{4}) (.*?$)/
    match = r.match(line)
    return nil if match.nil?
    direction = match[1]
    amount = match[2].to_f
    amount *= -1.0 if direction == 'expense'
    date = match[4]
    name = match[5]
    ExtraEvent.new(name, amount, date)
  end

  private def save_spend_event_for_line(line)
    r = /spending event (\d+(\.\d\d)?) (\d\d?-\d{4}) (.*?) \((\w+)\); start saving (\d\d?-\d{4})/
    match = r.match(line)
    return nil if match.nil?
    amount = match[1].to_f
    date = match[3]
    name = match[4]
    category = match[5].to_sym
    start_date = match[6]
    SaveSpendEvent.new(name, category, amount, date, start_date)
  end

  def starting_amount
    @input.each do |line|
      matches = /start with (\d+(\.\d\d)?)/.match line
      amount = matches[1]
      return amount.to_f unless amount.nil?
    end
    0
  end

  def skipped_input
    @input.select { |line| event_for_line(line).nil? }
          .reject { |l| l.start_with? 'start with' }
          .reject { |l| l == '' || l == "\n" }
  end
end
