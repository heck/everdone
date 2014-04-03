require 'everdone'

require 'minitest/autorun'

require 'config.rb'

require 'everdone/evernote.rb'

class EvernoteTest < MiniTest::Unit::TestCase
    def setup
        @evernote = Everdone::Evernote.new
    end

    def test_findNoteCounts
        assert_equal 0, @evernote.findNoteCounts("%$$%%$^@&& NOT IN EVERNOTE RIGHT? ^^{$^&*", Everdone::EVERNOTE_DEFAULT_NOTEBOOK)  # should not be found
        assert_equal 1, @evernote.findNoteCounts("#{Everdone::TODOIST_CONTENT_TAG}4653498", Everdone::EVERNOTE_DEFAULT_NOTEBOOK)  # known to be
        assert_equal 0, @evernote.findNoteCounts("#{Everdone::TODOIST_CONTENT_TAG}4653498", nil)  # known but not in this notebook
    end
end
