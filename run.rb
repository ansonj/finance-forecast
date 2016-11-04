#!/usr/bin/env ruby

require './lib/fin_parser.rb'
require './lib/generator.rb'
require './lib/reporter.rb'

parser = FinParser.new('input.txt')
events = parser.input_events
start_amount = parser.starting_amount

skipped_lines = parser.skipped_input
unless skipped_lines.count.zero?
  puts "Skipped #{skipped_lines.count} lines of input:"
  puts skipped_lines
end

generator = Generator.new(events, start_amount)
months = generator.output_months

reporter = Reporter.new(months)
puts reporter.text
reporter.write_html('output.html')
