#
# Class that keeps track of what's been synced
#
require 'time'
require 'json'

require 'everdone/todoist.rb'

module Everdone
    class Sync
        def initialize(config, todoist)
            @config = config
            @todoist = todoist
            @data = {}
            @current_item_id = nil
            items = @todoist.get_items_by_project_name(@config.todoist_sync_tracking_project)
            raise "Too many items in Todoist project used for syncing (#{@config.todoist_sync_tracking_project}): #{items.length}" if items.length > 1
            if items.length == 0 then
                initData()
            else
                @current_item_id = items[0]['id']
                notes = @todoist.get_notes(@current_item_id)
                unmarshall(notes[0]['content']) if notes and notes.length > 0
            end
        end

        def init_data
            @data['created'] = DateTime.now
            @data['processed'] = []
        end

        def is_already_processed(item_id)
            return  !@data['processed'].find_index(item_id).nil?
        end

        def close(new_processed)
            @data['processed'].concat(new_processed)
            new_item_id = @todoist.add_item_to_project_by_name(@config.todoist_sync_tracking_project, 
                "Evernote sync data from #{DateTime.now.to_s} total processed = #{self.get_processed_total()}",
                1)
            new_data = self.marshall
            @todoist.add_note(new_item_id, new_data)
            @todoist.delete_item_by_id(@current_item_id) if @current_item_id
        end

        def get_processed_total()
            return @data['processed'].length
        end

        def add_to_processed(new_processed)
            @data['processed'].push(new_processed)
        end

        def marshall
            data = JSON.generate(@data)
            return data
        end

        def unmarshall(data)
            @data = JSON.parse(data)
        end
    end
end