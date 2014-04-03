#
# Class that keeps track of what's been synced
#
require 'time'
require 'json'

require 'everdone/todoist.rb'

module Everdone
    class Sync
        def initData
            @data['created'] = DateTime.now
            @data['processed'] = []
        end

        def initialize(todoist)
            @todoist = todoist
            @data = {}
            @current_item_id = nil
            items = @todoist.getItemsByProjectName(TODOIST_SYNC_TRACKING_PROJECT)
            raise "Too many items in Todoist project used for syncing (#{TODOIST_SYNC_TRACKING_PROJECT}): #{items.length}" if items.length > 1
            if items.length == 0 then
                initData()
            else
                @current_item_id = items[0]['id']
                notes = @todoist.getNotes(@current_item_id)
                unmarshall(notes[0]['content']) if notes and notes.length > 0
            end
        end

        def isAlreadyProcessed(item_id)
            return  !@data['processed'].find_index(item_id).nil?
        end

        def close(new_processed)
            @data['processed'].concat(new_processed)
            new_item_id = @todoist.addItemToProjectByName(TODOIST_SYNC_TRACKING_PROJECT, 
                "Evernote sync data from #{DateTime.now.to_s} total processed = #{self.getProcessedTotal()}",
                1)
            new_data = self.marshall
            @todoist.addNote(new_item_id, new_data)
            @todoist.deleteItemById(@current_item_id) if @current_item_id
        end

        def getProcessedTotal()
            return @data['processed'].length
        end

        def addToProcessed(new_processed)
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