# # Handlebar JS Templates
# These templates are embeded in script tags and must be rendered to the 
# browser before the client script code is initialized, in order for 
# jQuery to locate them in the DOM
#
# ## Project List Template
# This template provides the markup for the project list view
script type: 'text/html', id: 'project-list', ->
  ul 'data-role': 'listview', 'data-filter': 'true', 'data-insert': 'true', ->
    "{{#each projects}}<li><a href='#' data-id='{{_id}}'>{{name}}</a></li>{{/each}}"


# ## Edit Form Template
# This template provides the markup for editing a project
# originally I was using static markup, but it made the code 
# more verbose, need to do some testing to see what is more
# expensive setting value via jQuery or rendering templates
# or does it matter....
script type: 'text/html', id: 'edit-form', ->
  form action: "/projects", method: 'post', ->
    div 'data-role': 'fieldcontain', ->
      label for: 'edit_name', -> 'Name'
      input type: 'text', name: 'name', id: 'edit_name', placeholder: 'project name', value: "{{name}}"
      label for: 'edit_description', -> 'Description'
      textarea name: 'description', id: 'edit_description', placeholder: 'description', ->
        "{{description}}"
      label for: 'edit_owner', -> 'Owner'
      input type: 'text', name: 'owner', id: 'edit_owner', placeholder: 'project owner', value: "{{owner}}"
    div 'data-role': 'fieldcontain', ->
      input type: 'submit', value: 'Update'
      a href: '#', 'data-role': 'button', 'data-action': 'cancel', -> 'Cancel'

# ## Show Project Template
# This template contains the markup to show a single project
# Again this seems to keep the code simple and not to have too
# much of an impact on rendering to the browser.
script type: 'text/html', id: 'show-content', ->
  div 'data-role': 'header', ->
    a href: '#', 'data-action': 'home', -> 'Projects'
    a href: '#', 'data-action': 'edit', -> 'Edit'
    h1 "The Grind"
  div 'data-role': 'content', ->
    ul id: 'details', 'data-role': 'listview', ->
      li 'data-role': 'list-divider', -> 'Name'
      li id: 'show_name', -> "{{name}}"
      li 'data-role': 'list-divider', -> 'Owner'
      li id: 'owner', -> "{{owner}}"
      li 'data-role': 'list-divider', -> 'Description'
      li id: 'description', -> "{{description}}"
  div 'data-role': 'header', ->
    h1 'Timeline'
    a href: '#', 'data-action': 'add_status', 'Add Status'
  div 'data-role': 'content', ->
    ul 'data-role': 'listview', ->
      "{{#each statuses}}<li>{{description}}</li>{{/each}}"



