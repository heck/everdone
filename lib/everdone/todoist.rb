require 'httparty'
require 'awesome_print'

require 'everdone/config'

require 'everdone/todoItem'

module Everdone
    class Todoist
        def initialize(config)
            @config = config
            @projects = {}  # map of project id's to project names
            @project_id_by_name = {}  # map of project names to id's
            projects = self.call_api('https://todoist.com/API/getProjects')
            projects.each { |project|  
                @projects[project['id']] = project['name']
                @project_id_by_name[project['name']] = project['id']
            }
            @labels = {}  # map of label id's to their name strings
            labels = self.call_api('https://todoist.com/API/getLabels')
            labels.each { |label|  
                @labels[label[1]['id']] = label[1]['name']
            }
        end

        # helper function for making RESTful calls
        def call_api(url, params=nil)
            query = { 'token' => @config.todoist_token }
            query.merge!(params) if params
            ret = HTTParty.post(url, {
              :query => query
            })

            if ret.response.code != "200"
              raise "ERROR: Error calling Todoist API #{url}\n   Response Code: #{ret.response.code}\n  Response: \n#{ret.response.body}"
            end
            return ret
        end

        def add_item_to_project_by_name(project_name, content, priority)
            ret = self.call_api('https://todoist.com/API/addItem', 
                params={'project_id'=>@project_id_by_name[project_name],'content'=>content, 'priority'=>priority})
            return ret['id']
        end

        def add_note(item_id, content)
            ret = self.call_api('https://todoist.com/API/addNote', params={'item_id'=>item_id,'content'=>content})  
            return ret
        end

        def get_completed_items()
            ret = [] # list of completed items converted into TodoItem objects
            interval = @config.todoist_completed_window
            items = self.call_api('https://todoist.com/API/getAllCompletedItems', params={'interval'=>interval})
            items['items'].each { |item|  
                todo_item = TodoItem.new(@config, item, @projects, @labels)
                ret.push(todo_item)
            }
            return ret
        end

        def get_item_by_id(id)
            ret = self.call_api('https://todoist.com/API/getItemsById', params={'ids'=>id})  # get a single item based on id
            return ret
        end

        def get_items_by_project_name(project_name)
            ret = self.call_api('https://todoist.com/API/getUncompletedItems', params={'project_id'=>@project_id_by_name[project_name]}) 
            return ret
        end

        def get_notes(item_id)
            ret = self.call_api('https://todoist.com/API/getNotes', params={'item_id'=>item_id})
            return ret
        end

        def complete_item_by_id(id)
            ret = self.call_api('https://todoist.com/API/completeItems', params={'ids'=>"[#{id}]"})
            return ret
        end

        def delete_item_by_id(id)
            ret = self.call_api('https://todoist.com/API/deleteItems', params={'ids'=>"[#{id}]"})
            return ret
        end
    end

    #
    ## getting a token via login
    #
    #login = HTTParty.post('https://todoist.com/API/login', {
    #  :query => {
    #    'email'=>'home@u2me.com',
    #    'password'=>'<insert password here>'
    #  }
    #})
    #
    #if login.response.code != "200"
    #  raise "Login unsuccessful.\n#{login.response.code}\n#{login.response.body}"
    #end
    #
    #puts "Login response was:"
    #puts login.body
    #puts
    #

    # for JSON responses, you can address keys in the response directly
    #token = login['token']

end
