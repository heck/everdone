require "everdone/version"

# TODO: Turn this into a gem.  Gemspec, etc. see: http://yehudakatz.com/2010/04/02/using-gemspecs-as-intended/ and http://guides.rubygems.org/what-is-a-gem/
# TODO: Refactor to GitHub Ruby coding standards: https://github.com/styleguide/ruby
# TODO: Preflight check vs. config.  Tokens work?  Projects, notebooks, tags needed all there?
require 'awesome_print'
require 'time'

require 'config.rb'

require 'everdone/evernote.rb'
require 'everdone/enmlformatter.rb'
require 'everdone/todoist.rb'
require 'everdone/sync.rb'


module Everdone
    @@evernote = Evernote.new
    @@todoist = Todoist.new

    def get_notebook_from_project(project)
        notebook = TODOIST_PROJECT_TO_EVERNOTE_NOTEBOOK_MAP[project]  # It is possible the project is in the map but the value is nil.  This means: don't add items from this project to Evernote
        if not TODOIST_PROJECT_TO_EVERNOTE_NOTEBOOK_MAP.has_key?(project)  # If the project is not in the map at all then put it in the default notebook
            notebook = EVERNOTE_DEFAULT_NOTEBOOK
        end
        return notebook
    end

    def self.sync
        sync = Sync.new(@@todoist)

        items = @@todoist.getCompletedItems()
        puts "INFO: Returned #{items.length} items"
        processed = []  # list of Todoist item ids that were processed
        found = []  # list of Todoist item ids not in the already processed list but subsequently found in Evernote
        excluded = [] # a list of Todoist item ids that were not added because they belong to a project that is blacklisted
        items.each { |item|
            if not sync.isAlreadyProcessed(item.id)
                # Map the project to an Evernote notebook
                notebook = get_notebook_from_project(item.projects[0])
                find_count = evernote.findNoteCounts("#{TODOIST_CONTENT_TAG}#{item.id}", notebook) if notebook
                if notebook.nil?
                    excluded.push(item.id)
                elsif find_count > 0
                    found.push(item.id)
                else  # not already processed nor in an ignored project nor was it found in Evernote.  Make a new one!
                    # Create the note's content
                    content = EnmlFormatter.new
                    content.text("Project: ").link(item.projects[0], item.getProjectURL(0))
                    if item.labels.length > 0
                        content.space.space.space.space
                        content.text("Labels: ")
                        item.labels.each { |label| 
                            content.link(label, item.getLabelURL(label)).space 
                        }
                    end
                    content.space.space.space.text("#{TODOIST_CONTENT_TAG}#{item.id}")
                    item.notes.each { |note|  
                        content.h3("Note created #{EnmlFormatter.datetimeToString(note.created, TODOIST_DATETIME_FORMAT)}   [Todoist note id: #{note.id}]")
                        content.rawtext(note.content)
                    }

                    # Create the note in Evernote
                    @@evernote.createNote(item.title, 
                        content.to_s, 
                        notebook,
                        Evernote.convertTextToTimestamp(item.created, TODOIST_DATETIME_FORMAT))
                end
                processed.push(item.id)  # whether item was added to Evernote or not don't process it again.
            end
        }

        # Finish up by doing the syncing bookwork
        sync.close(processed)

        puts "INFO: Done! Of #{items.length} found..."
        puts "  #{processed.length - (found.length+excluded.length)} added to Evernote"
        puts "  #{found.length} were already in Evernote"
        puts "  #{excluded.length} were not added as they are in blacklisted Todoist projects"
        puts "  All time total processed now #{sync.getProcessedTotal()}"
    end
end
