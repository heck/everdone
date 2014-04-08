require 'everdone'

require 'minitest/autorun'

require 'everdone/config'
require 'everdone/evernote'

class EvernoteTest < MiniTest::Unit::TestCase
    def setup
        @config = Everdone::Config.new("lib/everdone/default_config.json", "#{Dir.home}/.everdone")
        @evernote = Everdone::Evernote.new(@config)
    end

    def test_findNoteCounts
        assert_equal 0, @evernote.findNoteCounts("%$$%%$^@&& NOT IN EVERNOTE RIGHT? ^^{$^&*", @config.default_notebook)  # should not be found
        assert_equal 1, @evernote.findNoteCounts("#{@config.todoist_content_tag}4653498", @config.default_notebook)  # known to be
        assert_equal 0, @evernote.findNoteCounts("#{@config.todoist_content_tag}4653498", nil)  # known but not in this notebook
    end
end
