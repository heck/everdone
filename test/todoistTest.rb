require 'everdone'

require 'minitest/autorun'

require 'everdone/config'
require 'everdone/todoist'
require 'everdone/todoItem'

class TodoistTest < MiniTest::Unit::TestCase
    def setup
        @config = Everdone::Config.new("lib/everdone/default_config.json", "#{Dir.home}/.everdone")
        @todoist = Everdone::Todoist.new(@config)
    end

    KNOWN_TODOIST_COMPLETED_ID = 1155724
    def test_todoItem
        todo_item = @todoist.get_item_by_id(KNOWN_TODOIST_COMPLETED_ID)
    end
end
