Gem::Specification.new do |s|
  s.name                  = 'fluby'
  s.version               = '0.6.5'
  s.platform              = Gem::Platform::RUBY
  s.summary               = 'MTASC + SWFMILL + Rake helper'
  s.description           = 'A simple command to create an empty ActionScript project for MTASC + SWFMILL + Rake'
  s.homepage              = 'http://github.com/bomberstudios/fluby/'
  s.author                = 'Ale Muñoz'
  s.email                 = 'bomberstudios@gmail.com'

  s.rubyforge_project     = 'fluby'

  s.required_ruby_version = '>= 1.8.5'

  s.has_rdoc              = false
  s.files                 = Dir.glob(['README.mdown','Rakefile',"bin",'lib'])
  s.executables           = [ 'fluby' ]
  s.require_path          = 'lib'
  s.bindir                = 'bin'
end