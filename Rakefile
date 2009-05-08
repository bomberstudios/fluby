##### Requirements

require 'rake'

require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/testtask'

require File.dirname(__FILE__) + '/lib/fluby.rb'

##### Cleaning
CLEAN.include [ 'tmp', 'test/fixtures/*/output/*', 'test/fixtures/*/tmp' ]
CLOBBER.include [ 'pkg' ]

##### Packaging
spec = Gem::Specification.new do |s|
  s.name                  = Fluby::NAME
  s.version               = Fluby::VERSION
  s.platform              = Gem::Platform::RUBY
  s.summary               = 'A simple command to create an empty project for MTASC + SWFMILL + Rake'
  s.description           = s.summary
  s.homepage              = 'http://fluby.googlecode.com/'
  s.author                = 'Ale Muñoz'
  s.email                 = 'ale@bomberstudios.com'

  s.rubyforge_project     = 'fluby'

  s.required_ruby_version = '>= 1.8.5'

  s.has_rdoc              = false
  s.files                 = FileList.new("README.mdown","Rakefile","bin/**/*","lib/**/*").to_a
  s.executables           = [ 'fluby' ]
  s.require_path          = 'lib'
  s.bindir                = 'bin'
end

Rake::GemPackageTask.new(spec) { |task| }

task :install do
  if RUBY_PLATFORM =~ /mswin32/
    system('cmd.exe /c rake package')
    system("cmd.exe /c gem install pkg/#{Fluby::NAME}-#{Fluby::VERSION}")
  else
    system('rake package')
    system("sudo gem install pkg/#{Fluby::NAME}-#{Fluby::VERSION}")
  end
end

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

task :rcov do
  rm_f "coverage"
  rm_f "coverage.data"
  rcov = "rcov --exclude gem --aggregate coverage.data --text-summary -Ilib"
  sh "#{rcov} --no-html test/*", :verbose => false
end

task :default => [ :test ]
