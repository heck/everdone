# Load libraries required by the Evernote OAuth
require 'time'
require 'oauth'
require 'oauth/consumer'

# Load Thrift & Evernote Ruby libraries
require "evernote_oauth"

require 'config.rb'

module Everdone
    class Evernote
        # Set up the NoteStore client 
        @@evernote_client = EvernoteOAuth::Client.new(
            token: EVERNOTE_TOKEN,
            # additional_headers: my_user_agent
            sandbox: USE_SANDBOX  #default is true
        )
        @@note_store = @@evernote_client.note_store
        @@notebook_guids = {}
        notebooks = @@note_store.listNotebooks
        notebooks.each do |notebook|
            @@notebook_guids[notebook.name] = notebook.guid
        end
        @@tags = @@note_store.listTags
        @@tags.each { |tag| 
            if TAG_WITH and tag.name == TAG_WITH then
                @@tag_guid = tag.guid
                break
            end
        }

        def initialize()
        end

        def createNote(title, content, notebook, created)
            new_note = Evernote::EDAM::Type::Note.new()
            new_note.notebookGuid = @@notebook_guids[notebook]
            new_note.title = title.strip.slice(0..254).scan(/[[:print:]]/).join
            new_note.created = created
            new_note.content = content
            new_note.tagNames = [TAG_WITH] if TAG_WITH

            begin
                created_note = @@note_store.createNote(EVERNOTE_TOKEN, new_note)
            rescue => err
                puts "ERROR: ----------- Evernote exception ------------------!!!"
                ap err
                puts "Note info:"
                puts "Title: #{title}"
                puts "Created: #{created}"
                puts "Content:\n#{content}"
            end
            
        end

        # returns the count of notes within the context:
        #     In the notebook NOTEBOOK_TARGET with tag (if defined) TAG_WITH and having content (if defined) content_text
        def findNoteCounts(content_text, notebook)
            filter = ::Evernote::EDAM::NoteStore::NoteFilter.new()
            filter.notebookGuid = @@notebook_guids[notebook] if notebook
            filter.tagGuids = [@@tag_guid] if TAG_WITH
            filter.words = content_text if content_text
            ret = @@note_store.findNoteCounts(filter, false)
            # also: ret.tagCounts[@@tag_guid]
            return !ret.notebookCounts.nil? && notebook && ret.notebookCounts[@@notebook_guids[notebook]] ? ret.notebookCounts[@@notebook_guids[notebook]] : 0
        end

        def self.convertTextToTimestamp(dateText, dateFormat)
            ret = DateTime.strptime(dateText, dateFormat).to_time.to_i * 1000
            return ret
        end
    end
end
