Gem::Specification.new do |s|
  s.name                  = 'fluby'
  s.version               = '0.6.1'
  s.platform              = Gem::Platform::RUBY
  s.summary               = 'A simple command to create an empty ActionScript project for MTASC + SWFMILL + Rake'
  s.description           = s.summary
  s.homepage              = 'http://github.com/bomberstudios/fluby/'
  s.author                = 'Ale Muñoz'
  s.email                 = 'bomberstudios@gmail.com'

  s.rubyforge_project     = 'fluby'

  s.required_ruby_version = '>= 1.8.5'

  s.has_rdoc              = false
  s.files                 = [
    "README.mdown",
    "Rakefile",
    "bin/fluby",
    "lib/fluby.rb",
    "lib/templates/ASClass.as",
    "lib/templates/index.rhtml",
    "lib/templates/project.rxml",
    "lib/templates/Rakefile",
    "lib/templates/README",
    "lib/templates/swfobject.js",
    "lib/templates/generate",
    "lib/templates/generators/class",
    "lib/templates/generators/delegate",
    "lib/templates/generators/xml_loader"
  ]
  s.executables           = [ 'fluby' ]
  s.require_path          = 'lib'
  s.bindir                = 'bin'
end