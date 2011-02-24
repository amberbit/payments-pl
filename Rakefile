# encoding: UTF-8

require 'rubygems'
require 'rake'
require 'bundler'
Bundler::GemHelper.install_tasks

task :default => :spec

require 'yard'
require 'yard/rake/yardoc_task'

YARD::Rake::YardocTask.new do |t|
  version = File.exist?('VERSION') ? File.read('VERSION') : ''

  t.options += ['--title', "payments-pl #{version}"]
end
