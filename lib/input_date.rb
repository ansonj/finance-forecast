class InputDate
  include Comparable
  attr_accessor :month, :year

  def initialize(string)
    @month, @year = string.split('-').map { |s| s.to_i }
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
