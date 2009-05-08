##### Requirements

require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/testtask'

require File.dirname(__FILE__) + '/lib/fluby.rb'

##### Cleaning
CLEAN.include [ 'tmp', 'test/fixtures/*/output/*', 'test/fixtures/*/tmp' ]
CLOBBER.include [ 'pkg', '*.gem', 'coverage.data' ]

desc 'Build gem package'
task :gem do
  system('gem build fluby.gemspec')
end

desc 'Install gem'
task :install => :gem do
  if RUBY_PLATFORM =~ /mswin32/
    system('cmd.exe /c rake package')
    system("cmd.exe /c gem install pkg/#{Fluby::NAME}-#{Fluby::VERSION}")
  else
    system("sudo gem install pkg/#{Fluby::NAME}-#{Fluby::VERSION}")
  end
end

desc 'Uninstall gem'
task :uninstall do
  sh %{sudo gem uninstall #{Fluby::NAME}}
end

### Testing
Rake::TestTask.new(:test) do |test|
  test.test_files = Dir['test/test_*.rb']
end

desc 'Test if the gem will build on Github'
task :github do
  require 'yaml'
  require 'rubygems/specification'
  data = File.read('fluby.gemspec')
  spec = nil
  if data !~ %r{!ruby/object:Gem::Specification}
    Thread.new { spec = eval("$SAFE = 3\n#{data}") }.join
  else
    spec = YAML.load(data)
  end
  spec.validate
  puts spec
  puts "OK"
end

desc 'Test code coverage using rcov'
task :rcov do
  rm_f "coverage"
  rm_f "coverage.data"
  rcov = "rcov --exclude gem --aggregate coverage.data --text-summary -Ilib"
  sh "#{rcov} --no-html test/*", :verbose => false
end

task :default => [ :github, :test ]
