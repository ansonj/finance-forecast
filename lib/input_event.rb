require './lib/input_date.rb'

class InputEvent
  attr_accessor :name, :amount, :date

  def initialize(name, amount, date)
    @name = name
    @amount = amount
    @date = InputDate.new(date)
  end

  def type
    fail 'unknown InputEvent type'
  end

  def applies_to_date(date)
    date == @date
  end

  def ==(other)
    return false unless @name == other.name
    return false unless @amount == other.amount
    return false unless @date == other.date
    return false unless self.type == other.type
    true
  end
end

class SalaryEvent < InputEvent
  def type
    :salary
  end
end

class BillsEvent < InputEvent
  def type
    :bills
  end
end

class ExtraEvent < InputEvent
  def type
    :extra
  end
end

class SaveSpendEvent < InputEvent
  attr_accessor :category, :save_start_date

  def initialize(name, category, amount, date, start_date)
    @name = name
    @category = category
    @amount = amount
    @date = InputDate.new(date)
    @save_start_date = InputDate.new(start_date)

    raise 'Dates equal or out of order' if @date <= @save_start_date
  end

  def type
    :save_spend
  end

  def applies_to_date(date)
    @save_start_date <= date && date <= @date
  end

  def ==(other)
    return false unless method(:==).super_method.call(self)
    return false unless @category == other.category
    return false unless @save_start_date == other.save_start_date
    true
  end
end
