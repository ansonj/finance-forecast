require 'spec_helper'

describe Generator do
  it 'initializes properly' do
    events = [SalaryEvent.new('Testing', 345, '1-2016')]
    save_start = 99.99
    gen = Generator.new(events, save_start)
    gen.input_events.must_equal events
    gen.savings_starting_balance.must_equal save_start
  end

  describe 'output_months' do
    it 'works in an extremely simple case' do
      events = [SalaryEvent.new('Test salary', 30_000.00, '1-2016')]
      save_start = 0.0
      expected_months = -> {
        m = OutputMonth.new
        m.date = InputDate.new('1-2016')
        m.checking_before = 0
        m.income = 30_000.0
        m.expenses = 0
        m.net = 30_000
        m.checking_after = 30_000.0
        m.move_to_savings = 0
        m.checking_final = 30_000.0
        m.saving_before = 0
        m.savings_net = 0
        m.saving_after = 0
        m.salary_events = events
        m.bills_events = []
        m.extra_events = []
        m.save_spend_events = []
        [m]
      }.call

      months = Generator.new(events, save_start).output_months
      months.must_equal expected_months
    end

    it 'works in a basic case' do
      salary = SalaryEvent.new('Salary', 1_000, '1-2016')
      bills = BillsEvent.new('Bills', 500, '1-2016')
      extra = ExtraEvent.new('Get a bonus', 100, '3-2016')
      events = [salary, bills, extra]
      save_start = 0.0
      expected_months = -> {
        jan = OutputMonth.new
        jan.date = InputDate.new('1-2016')
        jan.checking_before = 0
        jan.income = 1000
        jan.expenses = 500
        jan.net = 500
        jan.checking_after = 500
        jan.move_to_savings = 0
        jan.checking_final = 500
        jan.saving_before = 0
        jan.savings_net = 0
        jan.saving_after = 0
        jan.salary_events = [salary]
        jan.bills_events = [bills]
        jan.extra_events = []
        jan.save_spend_events = []
        feb = OutputMonth.new
        feb.date = InputDate.new('2-2016')
        feb.checking_before = 500
        feb.income = 1000
        feb.expenses = 500
        feb.net = 500
        feb.checking_after = 1000
        feb.move_to_savings = 0
        feb.checking_final = 1000
        feb.saving_before = 0
        feb.savings_net = 0
        feb.saving_after = 0
        feb.salary_events = []
        feb.bills_events = []
        feb.extra_events = []
        feb.save_spend_events = []
        mar = OutputMonth.new
        mar.date = InputDate.new('3-2016')
        mar.checking_before = 1000
        mar.income = 1100
        mar.expenses = 500
        mar.net = 600
        mar.checking_after = 1600
        mar.move_to_savings = 0
        mar.checking_final = 1600
        mar.saving_before = 0
        mar.savings_net = 0
        mar.saving_after = 0
        mar.salary_events = []
        mar.bills_events = []
        mar.extra_events = [extra]
        mar.save_spend_events = []
        [jan, feb, mar]
      }.call

      months = Generator.new(events, save_start).output_months
      months.must_equal expected_months
    end

    it 'works with a SaveSpendEvent' do
      salary = SalaryEvent.new('Salary', 1_000, '1-2016')
      bills = BillsEvent.new('Bills', 300, '1-2016')
      save_spend = SaveSpendEvent.new('Vacation', :travel, 750, '3-2016', '1-2016')
      events = [salary, bills, save_spend]
      save_start = 100.0
      expected_months = -> {
        jan = OutputMonth.new
        jan.date = InputDate.new('1-2016')
        jan.checking_before = 0
        jan.income = 1000
        jan.expenses = 300
        jan.net = 700
        jan.checking_after = 700
        jan.move_to_savings = 375
        jan.checking_final = 325
        jan.saving_before = 100
        jan.savings_net = 375
        jan.saving_after = 475
        jan.salary_events = [salary]
        jan.bills_events = [bills]
        jan.extra_events = []
        jan.save_spend_events = [save_spend]
        feb = OutputMonth.new
        feb.date = InputDate.new('2-2016')
        feb.checking_before = 325
        feb.income = 1000
        feb.expenses = 300
        feb.net = 700
        feb.checking_after = 1025
        feb.move_to_savings = 375
        feb.checking_final = 650
        feb.saving_before = 475
        feb.savings_net = 375
        feb.saving_after = 850
        feb.salary_events = []
        feb.bills_events = []
        feb.extra_events = []
        feb.save_spend_events = [save_spend]
        mar = OutputMonth.new
        mar.date = InputDate.new('3-2016')
        mar.checking_before = 650
        mar.income = 1000
        mar.expenses = 300
        mar.net = 700
        mar.checking_after = 1350
        mar.move_to_savings = 0
        mar.checking_final = 1350
        mar.saving_before = 850
        mar.savings_net = -750
        mar.saving_after = 100
        mar.salary_events = []
        mar.bills_events = []
        mar.extra_events = []
        mar.save_spend_events = [save_spend]
        [jan, feb, mar]
      }.call

      months = Generator.new(events, save_start).output_months
      months.must_equal expected_months
    end
  end
end
