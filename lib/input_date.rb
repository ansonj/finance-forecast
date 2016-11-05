class InputDate
  include Comparable
  attr_accessor :month, :year

  def initialize(string)
    @month, @year = string.split('-').map { |s| s.to_i }
  end

  def next_month
    new_month = @month + 1
    new_year = @year
    if new_month > 12
      new_month = 1
      new_year += 1
    end
    InputDate.new("#{new_month}-#{new_year}")
  end

  def to_s
    "#{@month}-#{@year}"
  end

  def <=>(other)
    self_raw = (@year - 2000) * 12 + @month
    other_raw = (other.year - 2000) * 12 + other.month
    if self_raw < other_raw
      -1
    elsif self_raw > other_raw
      1
    else
      0
    end
  end
end
