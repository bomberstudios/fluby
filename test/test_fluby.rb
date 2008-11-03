require "fileutils"
require "test/unit"
require "test/helper"
require "lib/fluby"
require "erb"

class TestLibFluby < Test::Unit::TestCase
  def setup
    global_setup
  end
  def teardown
    global_teardown
  end

  def test_fluby_is_loaded
    assert_not_nil Fluby::VERSION
    assert_equal "fluby", Fluby::NAME
  end

  def test_project_creation
    assert_not_nil File.exist?(PROJECT)
  end

  def test_files_are_created_ok
    assert_equal 1, Dir["#{PROJECT}/*.as"].size
    assert_equal 1, Dir["#{PROJECT}/*.rxml"].size
    assert_equal 1, Dir["#{PROJECT}/*.rhtml"].size
    assert_equal 1, Dir["#{PROJECT}/deploy/swfobject.js"].size
  end

  def test_file_contents
    assert_equal ERB.new(IO.read("lib/templates/README")).result, File.read("#{PROJECT}/README")
    assert_equal ERB.new(IO.read("lib/templates/Rakefile")).result, File.read("#{PROJECT}/Rakefile")
    assert_equal ERB.new(IO.read("lib/templates/ASClass.as")).result, File.read("#{PROJECT}/#{PROJECT}.as")
  end

  def test_package
    %x(cd #{PROJECT};rake package;)
    now = Time.now.strftime("%Y%m%d")
    assert File.exist?("#{PROJECT}/pkg/#{now}-#{PROJECT}.zip")
  end
end