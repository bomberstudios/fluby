module Fluby
  NAME    = 'fluby'
  VERSION = '0.5.6'

  def self.create_project(name)
    require "fileutils"
    require "erb"

    @project_name = name
    @project_folder = FileUtils.pwd + "/" + @project_name

    # Make folders
    if File.exist? @project_folder
      puts "Folder #{@project_name} already exists,"
      puts "please choose a different name for your project"
      exit
    end
    FileUtils.mkdir [@project_folder,"#{@project_folder}/deploy","#{@project_folder}/assets"]

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

  end

  def self.copy_template source, destination=nil
    if destination.nil?
      destination = source
    end
    FileUtils.cp "#{File.dirname(__FILE__)}/templates/#{source}", "#{@project_folder}/#{destination}"
  end

  def self.render_template source, destination=nil
    if destination.nil?
      destination = source
    end
    open("#{@project_folder}/#{destination}","w") do |f|
      f << ERB.new(IO.read("#{File.dirname(__FILE__)}/templates/#{source}")).result(binding)
    end
  end
end