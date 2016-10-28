require 'spec_helper'

describe Canary do
  it 'passes the canary test' do
    Canary.test_value.must_equal true
  end
end
