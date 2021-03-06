class OutputMonth
  attr_accessor :date
  attr_accessor :checking_before, :income, :expenses, :net, :checking_after,
                :move_to_savings, :checking_final
  attr_accessor :saving_before, :savings_net, :saving_after
  attr_accessor :salary_events, :bills_events, :extra_events, :save_spend_events

  def ==(other)
    return false unless @date == other.date
    return false unless @checking_before == other.checking_before
    return false unless @income == other.income
    return false unless @expenses == other.expenses
    return false unless @net == other.net
    return false unless @checking_after == other.checking_after
    return false unless @move_to_savings == other.move_to_savings
    return false unless @checking_final == other.checking_final
    return false unless @saving_before == other.saving_before
    return false unless @savings_net == other.savings_net
    return false unless @saving_after == other.saving_after
    return false unless @salary_events == other.salary_events
    return false unless @bills_events == other.bills_events
    return false unless @extra_events == other.extra_events
    return false unless @save_spend_events == other.save_spend_events
    return true
  end
end
