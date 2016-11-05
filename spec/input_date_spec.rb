require 'spec_helper'

describe InputDate do
  it 'initializes properly' do
    date = InputDate.new('10-2016')
    date.month.must_equal 10
    date.year.must_equal 2016
  end

  describe 'next_month' do
    it 'works in a simple case' do
      month = InputDate.new('4-2016')
      month.next_month.must_equal InputDate.new('5-2016')
    end

    it 'works across a year boundary' do
      month = InputDate.new('12-2016')
      month.next_month.must_equal InputDate.new('1-2017')
    end
  end

  describe 'Comparable implementation' do
    it 'works with equality' do
      d1 = InputDate.new('1-2017')
      d2 = InputDate.new('1-2017')
      d1.must_equal d2
    end

    it 'works with less than' do
      d1 = InputDate.new('11-2016')
      d2 = InputDate.new('12-2016')
      d3 = InputDate.new('1-2017')

      d1.must_be :<, d2
      d1.must_be :<, d3
      d2.must_be :<, d3
    end

    it 'works with less than or equal' do
      d1 = InputDate.new('1-2017')
      d2 = InputDate.new('1-2017')
      d3 = InputDate.new('2-2017')

      d1.must_be :<=, d2
      d1.must_be :<=, d3
    end

    it 'works with greater than' do
      d1 = InputDate.new('11-2016')
      d2 = InputDate.new('12-2016')
      d3 = InputDate.new('1-2017')

      d3.must_be :>, d1
      d3.must_be :>, d2
      d2.must_be :>, d1
    end

    it 'works with greater than or equal' do
      d1 = InputDate.new('1-2017')
      d2 = InputDate.new('2-2017')
      d3 = InputDate.new('2-2017')

      d3.must_be :>=, d1
      d3.must_be :>=, d2
    end
  end
end
