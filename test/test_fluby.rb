require "test/helper"
require "test/unit"

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

  def test_compilation
    in_folder(PROJECT) do
      %x(rake compile)
      assert File.exist?("deploy/#{PROJECT}.swf"), "Compilation failed. Have you installed mtasc and swfmill?"
    end
  end

  def test_generator
    in_folder(PROJECT) do
      Fluby.available_templates.each do |tpl|
        Fluby.generate tpl, "com.bomberstudios.#{tpl}"
        assert File.exist?("com/bomberstudios/#{tpl}.as"), "Error generating #{tpl}"
      end
    end
  end

  def test_generator_with_single_option
    in_folder(PROJECT) do
      Fluby.generate "class", "com.bomberstudios.ClassTest", "foo:String"
      assert File.exist?("com/bomberstudios/ClassTest.as")
      assert_not_nil File.read("com/bomberstudios/ClassTest.as").match("var foo:String;")
    end
  end
  def test_generator_with_multiple_options
    in_folder(PROJECT) do
      Fluby.generate "class", "com.bomberstudios.ClassTest", "foo:String bar:XML"
      assert File.exist?("com/bomberstudios/ClassTest.as")
      assert_not_nil File.read("com/bomberstudios/ClassTest.as").match("var foo:String;")
      assert_not_nil File.read("com/bomberstudios/ClassTest.as").match("var bar:XML;")
    end
  end

  def test_available_templates
    assert_equal Dir["lib/templates/generators/*"].size, Fluby.available_templates.size, "Template count mismatch"
    in_folder PROJECT do
      templates = %x(script/generate)
      tpl_list = Fluby.available_templates.join("\n\t")
      assert_equal "Usage: script/generate type classpath [options]\nwhere type is one of\n\t#{tpl_list}\n", templates
    end
  end

  def test_package
    in_folder(PROJECT) do
      %x(rake package)
      now = Time.now.strftime("%Y%m%d")
      assert File.exist?("pkg/#{now}-#{PROJECT}.zip")
    end
  end
end