div 'data-role': 'page', id: 'edit', 'data-id': 'edit', ->
  div 'data-role': 'header', ->
    h1 'Edit Project'
  div 'data-role': 'content', ->
    form action: "/projects", method: 'post', ->
      div 'data-role': 'fieldcontain', ->
        label for: 'edit_name', -> 'Name'
        input type: 'text', name: 'name', id: 'edit_name', placeholder: 'project name'
        label for: 'edit_description', -> 'Description'
        textarea name: 'description', id: 'edit_description', placeholder: 'description'
        label for: 'edit_owner', -> 'Owner'
        input type: 'text', name: 'owner', id: 'edit_owner', placeholder: 'project owner'
      div 'data-role': 'fieldcontain', ->
        input type: 'submit', value: 'Update'
        a href: '#', 'data-role': 'button', 'data-action': 'cancel', -> 'Cancel'

