##### Requirements

require 'rake'
require 'rake/clean'
require 'rake/testtask'
require File.dirname(__FILE__) + '/lib/fluby.rb'

##### Jeweler
begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "fluby"
    gemspec.summary = "MTASC + SWFMILL + Rake helper"
    gemspec.description = "A simple command to create and compile an ActionScript project for MTASC + SWFMILL + Rake"
    gemspec.email = "bomberstudios@gmail.com"
    gemspec.homepage = "http://github.com/bomberstudios/fluby"
    gemspec.authors = ["Ale Muñoz"]
    gemspec.rubyforge_project     = 'fluby'
  end
  Jeweler::GemcutterTasks.new
  # release with: $ rake gemcutter:release
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

##### Cleaning
CLEAN.include [ 'tmp', 'test/fixtures/*/output/*', 'test/fixtures/*/tmp' ]
CLOBBER.include [ 'pkg', '*.gem', 'coverage.data' ]

### Testing
Rake::TestTask.new(:test) do |test|
  test.test_files = Dir['test/test_*.rb']
end

desc 'Test code coverage using rcov'
task :rcov do
  rm_f "coverage"
  rm_f "coverage.data"
  rcov = "rcov --exclude gem --aggregate coverage.data --text-summary -Ilib"
  sh "#{rcov} --no-html test/*", :verbose => false
end

task :default => [ :test, :gemspec ] do
  %x(gem build fluby.gemspec)
end

task :release => [ :clobber, :default ] do
  %x(rake gemcutter:release)
end