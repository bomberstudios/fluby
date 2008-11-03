require "lib/fluby"
PROJECT = "TestProject"
@project_name = PROJECT
@project_folder = @project_name
def global_setup
  make_project PROJECT
end
def global_teardown
  %x(rm -Rf #{PROJECT})
end
def make_project(name)
  Fluby.create_project(name)
end