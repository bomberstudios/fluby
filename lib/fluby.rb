require "rubygems"
require "erb"
require "yaml"
# require "rake"
require "fileutils"

module Fluby
  NAME    = 'fluby'
  COLORS = {
    :black => "\033[0;30m",
    :red => "\033[0;31m",
    :green => "\033[0;32m",
    :yellow => "\033[0;33m",
    :blue => "\033[0;34m",
    :purple => "\033[0;35m",
    :cyan => "\033[0;36m",
    :white => "\033[0;37m",
    :whitebold => "\033[1;37m"
  }

  def self.version
    %x(cat #{gem_path}/VERSION)
  end
  def self.gem_path
    File.dirname(__FILE__) + "/../"
  end
  def self.template_path
    gem_path + "/lib/templates"
  end
  def self.current_path
    Dir.pwd
  end
  def self.is_a_project?
    File.exist?("#{current_path}/index.rhtml")
  end

  # Project creation
  def self.create_project(name)
    # TODO: Support project creation in subfolders (i.e: fluby test/project)
    @project_name = name
    @project_folder = FileUtils.pwd + "/" + name

    puts "\n#{COLORS[:green]}Creating project #{name}"

    # Make folders
    if File.exist? @project_folder
      puts "#{COLORS[:red]}Folder #{name} already exists,"
      puts "#{COLORS[:red]}please choose a different name for your project"
      raise RuntimeError
    end
    FileUtils.mkdir [@project_folder,"#{@project_folder}/deploy","#{@project_folder}/assets","#{@project_folder}/script"], :verbose => false

    # Make files
    ["Rakefile","README","config.yml"].each do |file|
      render_template "#{template_path}/#{file}", "#{@project_folder}/#{file}"
    end

    # Static Templates
    copy_template "#{template_path}/index.rhtml", "#{@project_folder}/index.rhtml"
    copy_template "#{template_path}/project.rxml", "#{@project_folder}/#{name}.rxml"
    copy_template "#{template_path}/swfobject.js", "#{@project_folder}/assets/swfobject.js"

    # Main Class
    render_template "#{template_path}/ASClass.as", "#{@project_folder}/#{name}.as"

  end
  def self.copy_template source, destination
    FileUtils.cp source, destination, :verbose => false
    log "create", destination
  end
  def self.render_template source, destination=nil
    if destination.nil?
      destination = source
    end
    open(destination,"w") do |f|
      f << ERB.new(IO.read(source)).result(binding)
    end
    log "create", destination
  end
  def self.log type, string
    case type
    when "alert"
      puts "\t#{COLORS[:red]}Alert:\t#{string}#{COLORS[:white]}"
    when "create"
      puts "\t#{COLORS[:white]}Created:\t#{COLORS[:cyan]}#{string}#{COLORS[:white]}"
    end
  end
  def self.in_textmate?
    begin
      if TextMate
        return true
      end
    rescue
      return false
    end
  end
  def self.is_mac?
    return RUBY_PLATFORM =~ /darwin/
  end
  def self.has_growl?
    return is_mac? && !`which "growlnotify"`.empty?
  end
  def self.create *args
    create_project(*args[0])
  end

  # Utils
  def self.setup_debug
    debug_cfg_file = "/Library/Application\ Support/Macromedia/mm.cfg"
    system("touch '#{debug_cfg_file}'")
    File.open(debug_cfg_file,"w") do |f|
      f << <<-EOF
  ErrorReportingEnable=1
  TraceOutputFileEnable=1
EOF

    end unless File.exist?(debug_cfg_file)
    %x(touch "$HOME/Library/Preferences/Macromedia/Flash\ Player/Logs/flashlog.txt")
  end

  def self.available_templates
    return Dir["#{template_path}/generators/**"]
  end

  # Terminal
  def self.alert txt
    puts "\n\t#{COLORS[:red]}#{txt}#{COLORS[:white]}"
  end
  def self.say txt
    puts "\n\t#{COLORS[:green]}#{txt}#{COLORS[:white]}"
  end
  def self.txt txt=""
    puts "\t#{COLORS[:white]}#{txt}#{COLORS[:white]}"
  end

  # Project data
  def self.project_name
    options["app"]
  end
  def self.project_fullname
    "#{project_name} v#{options['version']}"
  end
  def self.options
    YAML.load_file('config.yml')
  end

  # Compilation
  def self.build *args
    if is_a_project?
      say "Building #{project_fullname}"
      assets
      preprocess
      compile
      notify if has_growl?
    else
      alert "This is not a fluby project!"
    end
  end
  def self.release *args
    @nodebug = true
    build
    @nodebug = false
  end
  def self.notify
    %x(growlnotify --name Rake -m 'Finished building #{project_name} in #{@end - @start} seconds')
  end
  def self.assets
    Dir.glob(['assets/*.js','assets/*.xml']).each do |file|
      FileUtils.cp file, "deploy/#{File.basename(file)}"
    end
  end
  def self.compile
    if @nodebug
      txt "Trace disabled"
      trace = " -trace no"
    else
      txt "Trace enabled"
      trace = ""
    end

    txt

    @start = Time.now

    render_template "index.rhtml", "index.html"
    render_template "#{project_name}.rxml", "#{project_name}.xml"

    txt

    system("swfmill simple #{project_name}.xml #{project_name}.swf")
    txt "√ swfmill"
    FileUtils.rm "#{project_name}.xml", {:verbose => false}

    system("mtasc -swf #{project_name}.swf -main -mx -version #{options["player"]} #{trace} #{project_name}.as")
    txt "√ mtasc"
    @end = Time.now

    ["*.html","*.swf"].each do |list|
      Dir[list].each do |file|
        FileUtils.mv file, "deploy/#{file}", {:verbose => false}
      end
    end
    say "Project compiled in #{@end - @start} seconds"
  end
  def self.preprocess
    
  end

  # Migration
  def self.update
    @project_name = current_path.split('/').last
    render_template "#{template_path}/config.yml", "#{current_path}/config.yml" unless File.exist?("#{current_path}/config.yml")
    FileUtils.mv "#{current_path}/Rakefile", "#{current_path}/Rakefile.old"
    render_template "#{template_path}/Rakefile", "#{current_path}/Rakefile"
    FileUtils.mv "#{current_path}/index.rhtml", "#{current_path}/index.rhtml.old"
    copy_template "#{template_path}/index.rhtml", "#{current_path}/index.rhtml"
    FileUtils.mv "#{current_path}/#{@project_name}.rxml", "#{current_path}/#{@project_name}.rxml.old"
    copy_template "#{template_path}/project.rxml", "#{current_path}/#{@project_name}.rxml"
  end

  def self.method_missing name
    options[name.to_s]
  end
end