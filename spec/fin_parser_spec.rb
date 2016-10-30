require 'spec_helper'

describe FinParser do
  describe 'initialize' do
    it 'copies the file contents into @input' do
      test_file = 'input.txt'
      File.exist?(test_file).must_equal true

      parser = FinParser.new(test_file)
      parser.input.wont_be_nil
    end

    it 'allows nil input' do
      parser = FinParser.new(nil)
      parser.input.must_be_nil
    end
  end

  describe 'input_events' do
    it 'needs to be tested'
  end

  describe 'starting_amount' do
    it 'needs to be tested'
  end
end
