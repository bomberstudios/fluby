require 'rake'

require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/testtask'

require File.dirname(__FILE__) + '/lib/fluby.rb'

Gem::Specification.new do |s|
  s.name                  = Fluby::NAME
  s.version               = Fluby::VERSION
  s.platform              = Gem::Platform::RUBY
  s.summary               = 'A simple command to create an empty project for MTASC + SWFMILL + Rake'
  s.description           = s.summary
  s.homepage              = 'http://github.com/bomberstudios/fluby/'
  s.author                = 'Ale Muñoz'
  s.email                 = 'bomberstudios@gmail.com'

  s.rubyforge_project     = 'fluby'

  s.required_ruby_version = '>= 1.8.5'

  s.has_rdoc              = false
  s.files                 = FileList.new("README.mdown","Rakefile","bin/**/*","lib/**/*").to_a
  s.executables           = [ 'fluby' ]
  s.require_path          = 'lib'
  s.bindir                = 'bin'
end