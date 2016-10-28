require 'minitest/spec'
require 'minitest/autorun'

require 'minitest/reporters'
use_spec = false
if use_spec
  Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
else
  plain_reporter = Minitest::Reporters::DefaultReporter.new(color: true)
  Minitest::Reporters.use! plain_reporter
end

Dir.glob('lib/*.rb').each do |file|
  require file.split('/').last
end

def not_implemented_yet
  it 'is not implemented yet' do
    raise to_s
  end
end
