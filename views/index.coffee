div 'data-role': 'page', ->
  div 'data-role': 'header', -> 
    h1 'The Grind - Projects'
    a href: '#add', -> 'Add Project'
  div 'data-role': 'content', ->
    ul 'data-role': 'listview', ->
      for project in @projects || []
        li ->
          a href: "/projects/#{project.name}", 'data-ajax': false, -> project.name

div id: 'add','data-role': 'page', 'data-id': 'add', ->
  div 'data-role': 'header', ->
    h1 'The Grind - New Project'
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


