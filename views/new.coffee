div id: 'new','data-role': 'page', 'data-id': 'new', ->
  div 'data-role': 'header', ->
    h1 'The Grind'
  div 'data-role': 'content', ->
    p 'Create a new Project'
    form action: '/projects', method: 'post', ->
      div 'data-role': 'fieldcontain', ->
        label for: 'new_name', -> 'Name'
        input type: 'text', name: 'name', id: 'new_name', placeholder: 'project name'
        label for: 'new_description', -> 'Description'
        textarea name: 'description', id: 'new_description', placeholder: 'description'
        label for: 'new_owner', -> 'Owner'
        input type: 'text', name: 'owner', id: 'new_owner', placeholder: 'project owner'
      div 'data-role': 'fieldcontain', ->
        input type: 'submit', value: 'Create'
        a href: '#', 'data-role': 'button', 'data-action': 'cancel', -> 'Cancel'


