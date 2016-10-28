require 'rake/testtask'

task default: :dev

Rake::TestTask.new do |t|
  t.pattern = 'spec/*_spec.rb'
  t.libs << 'spec'
  t.warning = false # TODO: remove this
end

desc 'Run rubocop\'s full suite'
task :rc do
  system 'rubocop'
end

desc 'Run rubocop, lint only'
task :rcl do
  system 'rubocop -l'
end

desc 'Run tests and rubocop (lint only)'
task dev: [:test, :rcl]

desc 'Start guard'
task :g do
  system 'bundle exec guard'
end
