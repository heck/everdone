require 'cgi'
require 'time'
require 'awesome_print'

require 'everdone/config'

#
# Class to help create the ENML (EverNote Markup Language) content
#

module Everdone
    class EnmlFormatter
        attr_reader :body

        def initialize(config)
            @config = config
            @body = ""
        end

        def text(text)
            @body = @body + text
            return self
        end

        # from: http://code.tutsplus.com/tutorials/8-regular-expressions-you-should-know--net-6149
        # match only url's that take the form http://..., https://... 
        # but NOT <whatever>@<url> or <host>.<domain>.<tld>
        URL_REGEX = /((https?:\/\/)([\da-zA-Z\.-]+)\.([a-z\.]{2,6})(:[\d]+)?([\/\w \.?%_&=+-]*)*\/?)/
        def rawtext(text)
            # Take text and do some cooking
            #
            # Escape HTML tags so Evernote doesn't freak out on them
            text = CGI::escapeHTML(text)
            # Remove newlines and insert HTML breaks (<br/>)
            text_lines = text.split(/\n/)
            text = ""
            text_lines.each { |line|  
                # Find URL-looking text and turn it into a link
                url_match = line.match(URL_REGEX)
                if url_match
                    url = url_match[1]
                    line.gsub!(url, "<a href='#{url}'>#{url}</a>") if url
                end
                text = text + "#{line}<br/>"
            }
            # Fix up some Todoist crap: Itâ€™s -> It's
            text.gsub!("â€™", "'");
            # Put it in the body
            @body = @body + text
            return self
        end

        def newline()
            @body = @body + "<br/>"
            return self
        end

        def h1(text)
            @body = @body + "<h1>#{text}</h1>"
            return self
        end

        def h2(text)
            @body = @body + "<h2>#{text}</h2>"
            return self
        end

        def h3(text)
            @body = @body + "<h3>#{text}</h3>"
            return self
        end

        def space
            @body = @body + "&nbsp;"
            return self
        end

        def link(text, url)
            @body = @body + "<a href='#{url}'>#{text}</a>"
            return self
        end

        def datetime_to_string(text, source_format)
            return DateTime.strptime(text, source_format).new_offset(DateTime.now.offset).strftime(@config.evernote_datetime_format)
        end

        def datetime(text, source_format)
            @body = @body + self.datetime_to_string(text, source_format)
            return self
        end

        def clear
            @body = ""
        end

        def to_s
            ret = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            ret = "<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\">"
            ret += "<en-note>#{@body}</en-note>"
            return ret
        end
    end
end