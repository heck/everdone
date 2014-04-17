# Everdone

A command line utility that takes completed tasks from Todooist and inserts them as entries into Evernote.

_Full disclosure: [Zapier](http://zapier.com) now supports pushing Todoist items to Evernote_

I still like my solution better as it gives finer control - and I wrote it.  :)

Likely this best serves as simple examples of using the Evernote and Todoist API's from Ruby.

## Installation

Add this line to your application's Gemfile:

    gem 'everdone'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install everdone

This utility depends on Todoist having a project named "EvernoteSync".  An item is added to this project to track all the Todoist item IDs that have already been added to Evernote.  This keeps the utility from needing to query Evernote to see if an item has already been copied.  Not as elegant a solution as I'd like.  (BTW, the utility does double-check with Evernote before adding a new item.)

## Usage

Everdone was written to be a command line utility, but to use it from a Ruby script...

    require 'everdone'

    Everdone.sync

Someday it should take options at the sync() call, but for now it starts with default options (included in this gem) and merges in options specified in the '.everdone' file in the caller's home directory.  The full set of options are:

```json
    {
        "default_notebook" : "<set to one of your Evernote notebooks>",
        "tag" : "Todoist",
        "evernote_datetime_format" : "%a %e %b %Y %H:%M",
        "use_evernote_sandbox" : false,
        "evernote_token" : "<get from: https://www.evernote.com/api/DeveloperToken.action>",

        "todoist_token" : "<get from your Todoist settings Account tab>",
        "todoist_completed_window" : "past 2 weeks",
        "todoist_datetime_format" : "%a %e %b %Y %H:%M:%S %z",
        "todoist_project_url" : "https://todoist.com/app?v=204#project/",
        "todoist_label_url" : "https://todoist.com/app?v=204#agenda/@",
        "todoist_sync_tracking_project" : "EvernoteSync",
        "todoist_content_tag" : "TodoistItemId",
        "todoist_link_title_regex" : "/\[\[[\w\s]+=[\h]+\s*,\s*([ -~]+)\]\]/",

        "todoist_evernote_map" : {
        }
    }
```

A basic set of options, in JSON format within your .everdone file, might look like:

    $ cat ~/.everdone 
    {
        "default_notebook" : "My Work Notebook",
        "evernote_token" : "S=s1:U=1f14:E=14c1<your Evernote dev token bits>de0626b34bc5ede7",
        "todoist_token" : "582a9<your Todoist API token bits>71ef5",
        "todoist_evernote_map" : {
            "Home" : "My Personal Notebook",
            "Hobby" : "My Hobby Notebook"
        }
    }

From the command line it looks like:

    $ everdone
    INFO: Returned 39 items
    INFO: Done! Of 39 found...
      1 added to Evernote
      All time total processed now 340

## The Present

Contains a nacent set of tests.

## The Future

See everdone.rb for a list of TODO's I have in mind.  Other, more minor TODO ideas are sprinked throughout the code. 
But I suspect this need will soon be fully met by Zapier.com or IFTTT.com.

## Contributing

1. Fork it ( http://github.com/heck/everdone/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
