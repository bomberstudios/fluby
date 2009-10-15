require "test/helper"
require "test/unit"
# TODO: test log
# TODO: test install

class TestFluby < Test::Unit::TestCase

  def setup
    global_setup
  end
  def teardown
    global_teardown
  end

  def test_fluby_is_loaded
    assert_not_nil Fluby.version
    assert_equal "fluby", Fluby::NAME
  end

  def test_project_creation
    assert_not_nil File.exist?(PROJECT)
  end
  def test_error_creating_existing_project
    assert_raise RuntimeError do
      make_project PROJECT
    end
  end

  def test_files_are_created_ok
    assert_equal 1, Dir["#{PROJECT}/*.as"].size
    assert_equal 1, Dir["#{PROJECT}/*.rxml"].size
    assert_equal 1, Dir["#{PROJECT}/*.rhtml"].size
    assert_equal 1, Dir["#{PROJECT}/assets/swfobject.js"].size
  end

  def test_file_contents
    assert_equal ERB.new(IO.read("lib/templates/README")).result, File.read("#{PROJECT}/README")
    assert_equal ERB.new(IO.read("lib/templates/Rakefile")).result, File.read("#{PROJECT}/Rakefile")
    assert_equal ERB.new(IO.read("lib/templates/ASClass.as")).result, File.read("#{PROJECT}/#{PROJECT}.as")
  end

  def test_compilation
    in_folder(PROJECT) do
      %x(fluby build)
      assert File.exist?("deploy/#{PROJECT}.swf"), "Compilation failed. Have you installed mtasc and swfmill?"
    end
  end

  def test_textmate
    assert !Fluby.in_textmate?
  end

  def test_package
    in_folder(PROJECT) do
      %x(rake package)
      now = Time.now.strftime("%Y%m%d")
      assert File.exist?("pkg/#{now}-#{PROJECT}.zip")
    end
  end
end