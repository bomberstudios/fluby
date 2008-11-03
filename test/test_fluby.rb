require "test/unit"
require "lib/fluby"

class TestLibFluby < Test::Unit::TestCase
  def test_fluby_is_loaded
    assert_not_nil Fluby::VERSION
    assert_equal "fluby", Fluby::NAME
  end
end