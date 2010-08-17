require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "payments-pl"
    gem.summary = %Q{Simple library for payments via platnosci.pl}
    gem.description = %Q{Simple library for payments via platnosci.pl}
    gem.email = "m.mlozniak@gmail.com"
    gem.homepage = "http://github.com/ronin/payments-pl"
    gem.authors = ["Michał Młoźniak"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'yard'
require 'yard/rake/yardoc_task'

YARD::Rake::YardocTask.new do |t|
  version = File.exist?('VERSION') ? File.read('VERSION') : ''

  t.options += ['--title', "payments-pl #{version}"]
end
