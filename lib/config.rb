module Everdone
    #
    # Evernote global constants
    #
    EVERNOTE_DEFAULT_NOTEBOOK = "NetMotion"
    TAG_WITH = "Todoist"
    EVERNOTE_DATETIME_FORMAT = "%a %e %b %Y %H:%M"

    # sandbox
    # EVERNOTE_TOKEN = "S=s1:U=8ad6d:E=14c19383eca:C=144c18712cc:P=1cd:A=en-devtoken:V=2:H=1099d548cfc13c5f2d9d379c13a32ad1";
    # USE_SANDBOX = true

    # production
    EVERNOTE_TOKEN = "S=s1:U=1f14:E=14c193a89a5:C=144c1895da8:P=1cd:A=en-devtoken:V=2:H=cb33d375b36b6243de0626b34bc5ede7";  # see: https://www.evernote.com/api/DeveloperToken.action
    USE_SANDBOX = false

    #
    # Todoist global constants
    #
    TODOIST_TOKEN = "582a9a292eacd5d9946f9f1f44d4f0a3c1e71ef5" # obtain from your Todoist settings
    TODOIST_COMPLETED_ITEMS_WINDOW = "past 2 weeks"  # could also be one of: "past month", "past 6 months", "all"
    TODOIST_DATETIME_FORMAT = "%a %e %b %Y %H:%M:%S %z"  # "Mon 10 Mar 2014 15:45:01 +0000"
    TODOIST_PROJECT_URL = "https://todoist.com/app?v=204#project/" # followed by project id
    TODOIST_LABEL_URL = "https://todoist.com/app?v=204#agenda/@"  # followed by label name
    TODOIST_SYNC_TRACKING_PROJECT = "EvernoteSync"
    TODOIST_CONTENT_TAG = "TodoistItemId"
    TODOIST_LINK_TITLE_REGEX = /\[\[[\w\s]+=[\h]+\s*,\s*([ -~]+)\]\]/

    #
    # Todoist and Evernote shared globals
    #
    TODOIST_PROJECT_TO_EVERNOTE_NOTEBOOK_MAP = {
        # Any item whos project is not listed will go into the EVERNOTE_DEFAULT_NOTEBOOK
        # To keep a project's items out of Evernote altogether, set its result to nil (e.g. "Not This Project" => nil)
        "Home" => "sheckt",
        "QFC" => "sheckt",
        "PCC" => "sheckt",
        "Costco" => "sheckt",
        "Bartells" => "sheckt",
        "Projects" => "sheckt",
        "Home Depot" => "sheckt"
    }
end