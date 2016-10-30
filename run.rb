#!/usr/bin/env ruby

require './lib/fin_parser.rb'
require './lib/generator.rb'
require './lib/reporter.rb'

parser = FinParser.new('input.txt')
events = parser.input_events
start = parser.starting_amount

generator = Generator.new(events, start)
months = generator.output_months

reporter = Reporter.new(months)
puts reporter.text
reporter.write_html('output.html')
