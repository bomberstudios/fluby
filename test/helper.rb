require "lib/fluby"
require "fileutils"
require "erb"
require "stringio"

PROJECT = "TestProject"
APP = PROJECT
@project_name = PROJECT
@project_folder = @project_name

def global_setup
  # Go quiet
  $stdout_real = $stdout
  $stderr_real = $stderr
  unless ENV['QUIET'] == 'false'
    $stdout = StringIO.new
    $stderr = StringIO.new
  end
  make_project PROJECT
end

def global_teardown
  %x(rm -Rf #{PROJECT})
  # Go unquiet
  unless ENV['QUIET'] == 'false'
    $stdout = $stdout_real
    $stderr = $stderr_real
  end
end
def make_project(name)
  Fluby.create_project(name)
end

def in_folder(name)
  FileUtils.cd(name) do
    yield
  end
end