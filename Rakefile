# encoding: UTF-8

require 'rubygems'
require 'rake'
require 'bundler'
Bundler::GemHelper.install_tasks

require 'yard'
require 'yard/rake/yardoc_task'

YARD::Rake::YardocTask.new do |t|
  version = File.exist?('VERSION') ? File.read('VERSION') : ''

  t.options += ['--title', "payments-pl #{version}"]
end

require "rspec/core/rake_task"

task :default => :spec

desc "Run all specs"
RSpec::Core::RakeTask.new do |t|
  t.ruby_opts = "-w"
  t.verbose = true
  t.skip_bundler = true
end
