#
# TodoItem
#   Handle mapping a single Todoist itme to something EverTodo can work with
#
require 'awesome_print'

require 'everdone/config'

module Everdone
    class TodoNote
        attr_reader :id, :created, :content
        def initialize(todoist_note)
            note = todoist_note
            @id = note['id']
            @created = note['posted']
            @content = note['content']
        end
    end

    class TodoItem
        attr_reader :id, :title, :created, :projects, :project_ids, :labels, :notes, :priority, :due_date
        def initialize(config, todoist_item, projects, labels)
            @config = config
            item = todoist_item
            @id = item['id']
            @title = item['content']
            clean_title()  # strip off all (known) Todoist detritus
            @created = item['completed_date']
            @projects = []  # Just the parent for now.  TODO: array of projects starting with senior parent and working down to immediate parent
            @projects.push(projects[item['project_id']])
            @project_ids = []  # Just the parent for now.  TODO: array of project ids starting with senior... (see above)
            @project_ids.push(item['project_id'])
            @labels = []  # arrary of associated labels (random order)
            item['labels'].each { |labelId|
                @labels.push(labels[labelId])
            }
            @priority = item['priority']
            @due_date = item['due_date']
            @notes = []  # array of notes
            if not item['notes'].nil?
                item['notes'].each { |note|
                    new_note = TodoNote.new(note)
                    @notes.push(new_note)
                }
            end
        end

        def clean_title()
            cleaned_title = @title.match(@config.todoist_link_title_regex)
            @title = cleaned_title.nil? ? @title : cleaned_title[1].strip
        end

        def get_project_url(project_index)
            return @config.todoist_project_url + @project_ids[project_index].to_s
        end

        def get_label_url(label)
            return @config.todoist_label_url + label
        end
    end
end
