class Generator
  attr_reader :input_events, :savings_starting_balance

  def initialize(events, start = 0)
    @input_events = events
    @savings_starting_balance = start
  end

  def output_months
    current_month = earliest_month_in @input_events
    last_month = latest_month_in @input_events

    checking_balance = 0.0
    savings_balance = @savings_starting_balance
    running_income = 0.0
    running_expenses = 0.0

    output_months = []

    while current_month <= last_month
      relevant_events = @input_events.select { |e| e.applies_to_date(current_month) }

      output = OutputMonth.new
      output.date = current_month

      salary = relevant_events.select { |e| e.type == :salary }
      bills = relevant_events.select { |e| e.type == :bills }
      extra = relevant_events.select { |e| e.type == :extra }
      save_spend = relevant_events.select { |e| e.type == :save_spend }

      output.salary_events = salary
      output.bills_events = bills
      output.extra_events = extra
      output.save_spend_events = save_spend

      output.checking_before = checking_balance

      running_income += salary.inject(0) { |sum, e| sum + e.amount }
      output.income = running_income + extra.select { |e| e.amount > 0 }
                                            .inject(0) { |sum, e| sum + e.amount }

      running_expenses += bills.inject(0) { |sum, e| sum + e.amount }
      output.expenses = running_expenses - extra.select { |e| e.amount < 0 }
                                                .inject(0) { |sum, e| sum + e.amount }

      output.net = output.income - output.expenses
      output.checking_after = output.checking_before + output.net

      output.move_to_savings = save_spend.select { |e| e.date > current_month }
                                         .inject(0) { |sum, e| sum + e.saving_increment }
      output.checking_final = output.checking_after - output.move_to_savings

      output.saving_before = savings_balance
      output.savings_net = output.move_to_savings - save_spend.select { |e| e.date == current_month }
                                                              .inject(0) { |sum, e| sum + e.amount }
      output.saving_after = output.saving_before + output.savings_net

      checking_balance = output.checking_final
      savings_balance = output.saving_after

      output_months << output
      current_month = current_month.next_month
    end

    output_months
  end

  private def earliest_month_in(events)
    all_months_in(events).min
  end

  private def latest_month_in(events)
    all_months_in(events).max
  end

  private def all_months_in(events)
    months = events.map { |e| e.date }
    months += events.select { |e| e.type == :save_spend }
                    .map { |e| e.save_start_date }
    months
  end
end
