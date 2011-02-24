# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "payments_pl/version"

Gem::Specification.new do |s|
  s.name        = "payments_pl"
  s.version     = PaymentsPl::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Michał Młoźniak"]
  s.email       = ["m.mlozniak@gmail.com"]
  s.homepage    = "http://github.com/ronin/payments-pl"
  s.summary     = %q{Simple library for payments via platnosci.pl}
  s.description = %q{Simple library for payments via platnosci.pl}

  s.rubyforge_project = "payments_pl"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.rdoc_options = ["--charset=UTF-8"]
  
  s.add_dependency 'activesupport', '~>3.0.0'
  s.add_dependency 'i18n', '~>0.5.0'
  s.add_development_dependency 'rspec', '~>2.5.0'
  s.add_development_dependency 'yard', '~>0.6.0'
end
