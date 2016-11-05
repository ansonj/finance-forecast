require 'spec_helper'

describe 'OutputMonth' do
  describe '==' do
    before(:each) do
      month_factory = -> {
        m = OutputMonth.new
        m.date = InputDate.new('1-2016')
        m.checking_before = 1
        m.income = 2
        m.expenses = 3
        m.net = 4
        m.checking_after = 5
        m.total_save = 6
        m.checking_final = 7
        m.saving_before = 8
        m.saving_after = 9
        m.salary_events = [SalaryEvent.new('Test', 10, '1-2016')]
        m.bills_events = [BillsEvent.new('More', 20, '2-2016')]
        m.extra_events = [ExtraEvent.new('Extry', 30, '3-2016')]
        m.save_spend_events = [SaveSpendEvent.new('Save it', :vacation, 42, '12-2016', '1-2016')]
        m
      }
      @expected = month_factory.call
      @test_month = month_factory.call
    end

    it 'works for equality' do
      @test_month.must_equal @expected
    end

    it 'checks date' do
      @test_month.date = InputDate.new('1-2017')
      @test_month.wont_equal @expected
    end

    it 'checks checking_before' do
      @test_month.checking_before = -999
      @test_month.wont_equal @expected
    end

    it 'checks income' do
      @test_month.income = -999
      @test_month.wont_equal @expected
    end

    it 'checks expenses' do
      @test_month.expenses = -999
      @test_month.wont_equal @expected
    end

    it 'checks net' do
      @test_month.net = -999
      @test_month.wont_equal @expected
    end

    it 'checks checking_after' do
      @test_month.checking_after = -999
      @test_month.wont_equal @expected
    end

    it 'checks total_save' do
      @test_month.total_save = -999
      @test_month.wont_equal @expected
    end

    it 'checks checking_final' do
      @test_month.checking_final = -999
      @test_month.wont_equal @expected
    end

    it 'checks saving_before' do
      @test_month.saving_before = -999
      @test_month.wont_equal @expected
    end

    it 'checks saving_after' do
      @test_month.saving_after = -999
      @test_month.wont_equal @expected
    end

    it 'checks salary_events' do
      @test_month.salary_events = []
      @test_month.wont_equal @expected
    end

    it 'checks bills_events' do
      @test_month.bills_events = []
      @test_month.wont_equal @expected
    end

    it 'checks extra_events' do
      @test_month.extra_events = []
      @test_month.wont_equal @expected
    end

    it 'checks save_spend_events' do
      @test_month.save_spend_events = []
      @test_month.wont_equal @expected
    end
  end
end
