#
# Class to handle reading, writing, and encapsulating JSON-based app config

# TODO: Preflight check vs. config.  Tokens work?  Projects, notebooks, tags needed all there?

require 'json'

module Everdone
    class Config
        def initialize(default_hash_file, user_settings_file)
            @defaults = unmarshall_from_file(default_hash_file)
            @user_settings_file = user_settings_file
            @users = unmarshall_from_file(@user_settings_file)
            @current = {}

            collate_settings()
        end

        private

        def define_instance_var(name, value)
            self.class.module_eval { attr_accessor name.to_sym }
            instance_variable_set("@#{name}", value)
        end

        # return a string of JSON for the current settings
        def marshall_to_string()
            current = JSON.generate(@current)
            return current
        end

        def unmarshall_from_string(new_config)
            return JSON.parse(new_config)
        end 

        def marshall_to_file(filename)
        end

        def unmarshall_from_file(filename)
            users = {}
            return users if not File.exist?(filename)
            File.open(filename, "r") do |f|
                users = JSON.load(f)
            end
            return users
        end

        def collate_settings
            # add all the settings (every setting has a default) as a member variable of this class
            @defaults.each { |name, val|  
                define_instance_var(name,val)
            }
            # combine the default settings and the settings from the user file into the current settings
            @current = @defaults
            @users.each { |name, val|  
                if @current.has_key?(name)
                    @current[name] = val
                    instance_variable_set("@#{name}", val)
                else
                    puts "WARN: the settings file #{@user_settings_file} contained an unrecognized setting #{name} (value = #{val})"
                end
            }
        end
    end
end