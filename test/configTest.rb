require 'everdone'
require 'awesome_print'

require 'minitest/autorun'

require 'everdone/config.rb'
require 'json'

class ConfigTest < MiniTest::Unit::TestCase
    def setup
    end

    def test_initialize
        config = Everdone::Config.new("test/config_1.json", "test/config_empty")
        assert_equal "this is string_1", config.string_1
        assert_equal 1, config.int_1
        assert_equal 1.1, config.float_1
        assert_equal "second_string", config.string_array_1[1]
        assert_equal "value 1", config.hash_1["key_1"]
    end

    def test_initialze_with_user_settings
        config = Everdone::Config.new("test/config_1.json", "test/config_partial")
        assert_equal "this is THE NEW string_2", config.string_2
        assert_equal 2.2, config.float_1
        assert_equal 3, config.hash_1["key_2"]
    end
end
