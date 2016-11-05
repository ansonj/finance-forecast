require 'spec_helper'

describe InputEvent do
  describe 'initialize' do
    it 'works properly' do
      name = 'Test'
      amount = 424.2
      date = '4-2012'
      e = InputEvent.new(name, amount, date)
      e.name.must_equal name
      e.amount.must_equal amount
      e.date.must_equal InputDate.new(date)
    end

    it 'has a special case for SaveSpendEvent' do
      name = 'Trip to Disney World'
      category = :travel
      amount = 4000
      date = '6-2017'
      start_date = '8-2016'
      e = SaveSpendEvent.new(name, category, amount, date, start_date)
      e.name.must_equal name
      e.category.must_equal category
      e.amount.must_equal amount
      e.date.must_equal InputDate.new(date)
      e.save_start_date.must_equal InputDate.new(start_date)
    end

    it 'fails if SaveSpendEvent is given equal dates' do
      date = '3-2017'
      lambda { SaveSpendEvent.new('Name', :test, 123, date, date) }.must_raise RuntimeError
    end

    it 'fails if SaveSpendEvent is given dates out of order' do
      event_date = '3-2018'
      start_date = '3-2017'
      lambda { SaveSpendEvent.new('Name', :test, 123, start_date, event_date) }.must_raise RuntimeError
    end
  end

  describe 'applies_to_date' do
    describe 'for InputEvent' do
      it 'doesn\'t apply if date is too early' do
        event = SalaryEvent.new('Test event', 123, '5-2016')
        test_date = InputDate.new('4-2016')
        event.applies_to_date(test_date).must_equal false
      end

      it 'applies if date is a match' do
        event = SalaryEvent.new('Test event', 123, '5-2016')
        test_date = InputDate.new('5-2016')
        event.applies_to_date(test_date).must_equal true
      end

      it 'doesn\'t apply if the date is after' do
        event = SalaryEvent.new('Test event', 123, '5-2016')
        test_date = InputDate.new('6-2016')
        event.applies_to_date(test_date).must_equal false
      end
    end

    describe 'for SaveSpendEvent' do
      it 'doesn\'t apply if the date is before the start date' do
        event = SaveSpendEvent.new('Test event', :testing, 123.45, '10-2016', '1-2016')
        test_date = InputDate.new('12-2015')
        event.applies_to_date(test_date).must_equal false
      end

      it 'applies if the date is the start date' do
        event = SaveSpendEvent.new('Test event', :testing, 123.45, '10-2016', '1-2016')
        test_date = InputDate.new('1-2016')
        event.applies_to_date(test_date).must_equal true
      end

      it 'applies if the date is between the start and end date' do
        event = SaveSpendEvent.new('Test event', :testing, 123.45, '10-2016', '1-2016')
        test_date = InputDate.new('5-2016')
        event.applies_to_date(test_date).must_equal true
      end

      it 'applies if the date is the end date' do
        event = SaveSpendEvent.new('Test event', :testing, 123.45, '10-2016', '1-2016')
        test_date = InputDate.new('10-2016')
        event.applies_to_date(test_date).must_equal true
      end

      it 'doesn\'t apply if the date is after the end date' do
        event = SaveSpendEvent.new('Test event', :testing, 123.45, '10-2016', '1-2016')
        test_date = InputDate.new('11-2016')
        event.applies_to_date(test_date).must_equal false
      end
    end
  end

  describe 'saving_increment' do
    it 'works in a simple case for one month' do
      event = SaveSpendEvent.new('Test event', :testing, 100.0, '2-2017', '1-2017')
      event.saving_increment.must_equal 100.0
    end

    it 'works for more than one month' do
      event = SaveSpendEvent.new('Test event', :testing, 100.0, '11-2017', '1-2017')
      event.saving_increment.must_equal 10.0
    end
  end

  describe '==' do
    it 'detects equality' do
      name = 'Starting salary'
      amount = 55000
      date = '1-2016'
      e1 = SalaryEvent.new(name, amount, date)
      e2 = SalaryEvent.new(name, amount, date)
      e1.must_equal e2
    end

    it 'requires equal names' do
      amount = 12
      date = '12-2012'
      e1 = BillsEvent.new('asdf', amount, date)
      e2 = BillsEvent.new('jkl', amount, date)
      e1.wont_equal e2
    end

    it 'requires equal amounts' do
      name = 'Title'
      date = '11-2011'
      e1 = ExtraEvent.new(name, 11, date)
      e2 = ExtraEvent.new(name, 22, date)
      e1.wont_equal e2
    end

    it 'requires equal dates' do
      name = 'Some name'
      amount = 123.4
      e1 = BillsEvent.new(name, amount, '3-2017')
      e2 = BillsEvent.new(name, amount, '4-2017')
      e1.wont_equal e2
    end

    it 'requires equal types' do
      name = 'A good name'
      amount = 3.14
      date = '3-2014'
      e1 = SalaryEvent.new(name, amount, date)
      e2 = BillsEvent.new(name, amount, date)
      e1.wont_equal e2
    end

    it 'requires equal start dates for SaveSpendEvent' do
      name = 'Buy a new car'
      category = :long_term
      amount = 35000
      date = '12-2019'
      start_date1 = '1-2019'
      start_date2 = '2-2019'
      e1 = SaveSpendEvent.new(name, category, amount, date, start_date1)
      e2 = SaveSpendEvent.new(name, category, amount, date, start_date2)
      e1.wont_equal e2
    end

    it 'requires equal categories for SaveSpendEvent' do
      name = 'Buy a new car'
      c1 = :life
      c2 = :big_purchases
      amount = 35000
      date = '12-2019'
      start_date = '1-2019'
      e1 = SaveSpendEvent.new(name, c1, amount, date, start_date)
      e2 = SaveSpendEvent.new(name, c2, amount, date, start_date)
      e1.wont_equal e2
    end
  end
end
