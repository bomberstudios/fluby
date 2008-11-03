require "erb"
require "fileutils"

module Fluby
  NAME    = 'fluby'
  VERSION = '0.5.8'

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

  def self.create_project(name)
    require "fileutils"
    require "erb"

    # TODO: Support project creation in subfolders (i.e: fluby test/project)
    @project_name = name
    @project_folder = FileUtils.pwd + "/" + @project_name

    puts "\n#{COLORS[:green]}Creating project #{@project_name}"

    # Make folders
    if File.exist? @project_folder
      puts "#{COLORS[:red]}Folder #{@project_name} already exists,"
      puts "#{COLORS[:red]}please choose a different name for your project"
      exit
    end
    FileUtils.mkdir [@project_folder,"#{@project_folder}/deploy","#{@project_folder}/assets","#{@project_folder}/script"]

    # Make files
    ["Rakefile","README"].each do |file|
      render_template file
    end

    # Static Templates
    copy_template "index.rhtml"
    copy_template "project.rxml", "#{@project_name}.rxml"
    copy_template "swfobject.js", "deploy/swfobject.js"

    # Main Class
    render_template "ASClass.as", "#{@project_name}.as"

    # script/generate
    render_template "generate", "script/generate"
    %x(chmod 755 "#{@project_folder}/script/generate")

    if in_textmate?
      puts "Oh, my, what a nice editor you're using"
    end
  end

  def self.copy_template source, destination=nil
    if destination.nil?
      destination = source
    end
    FileUtils.cp "#{File.dirname(__FILE__)}/templates/#{source}", "#{@project_folder}/#{destination}"
    log "create", "#{@project_name}/#{destination}"
  end

  def self.render_template source, destination=nil
    if destination.nil?
      destination = source
    end
    open("#{@project_folder}/#{destination}","w") do |f|
      f << ERB.new(IO.read("#{File.dirname(__FILE__)}/templates/#{source}")).result(binding)
    end
    log "create", "#{@project_name}/#{destination}"
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

  # these functions are used by script/generate
  def self.generate(type, name, options=nil)
    target_path = File.dirname(name.split(".").join("/").to_s)
    target_file = name.split(".").join("/") + ".as".to_s
    if File.exist?(target_file)
      log "alert", "File #{target_file} already exists!"
      return
    end
    FileUtils.mkdir_p target_path unless File.exist? target_path
    @classpath = target_path.split("/").join(".")
    @classname = name.split(".").last
    File.open(target_file,"w") do |file|
      file << ERB.new(File.read("#{template_path}/generators/#{type}")).result(binding)
    end
    log "create", "#{target_path}/#{@classname}.as"
  end

  def self.path
    File.dirname(__FILE__)
  end
  def self.template_path
    path + "/templates"
  end
  def self.available_templates
    templates = {}
    Dir["#{template_path}/generators/**"].each do |file|
      templates[File.basename(file)] = file
    end
  end
end