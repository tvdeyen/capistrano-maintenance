# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require "capistrano"
require "capistrano/maintenance/version"

Gem::Specification.new do |s|
  s.name        = 'capistrano-maintenance'
  s.version     = Capistrano::Maintenance::VERSION
  s.platform    = Gem::Platform::RUBY
  s.license     = 'MIT'
  s.author      = 'Thomas von Deyen'
  s.email       = 'tvd@magiclabs.de'
  s.homepage    = 'https://github.com/tvdeyen/capistrano-maintenance'
  s.summary     = %q{Offers deploy:web:disable and deploy:web:enable tasks for Capistrano.}
  s.description = %q{The deploy:web tasks where removed from Capistrano core. This extension brings them back.}

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency 'capistrano', ['>= 2.0.0']
end
