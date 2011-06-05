div id: 'add','data-role': 'page', 'data-id': 'add', ->
  div 'data-role': 'header', ->
    h1 'The Grind'
  div 'data-role': 'content', ->
    p 'Create a new Project'
    form action: '/projects', method: 'post', ->
      div 'data-role': 'fieldcontain', ->
        label for: 'project_name', -> 'Name'
        input type: 'text', name: 'name', id: 'project_name', placeholder: 'project name'
        label for: 'project_description', -> 'Description'
        textarea name: 'description', id: 'project_description', placeholder: 'description'
        label for: 'project_owner', -> 'Owner'
        input type: 'text', name: 'owner', id: 'project_owner', placeholder: 'project owner'
      div 'data-role': 'fieldcontain', ->
        input type: 'submit', value: 'Create'
        a href: '/', 'data-role': 'button', -> 'Cancel'


