div 'data-role': 'page', id: 'edit', 'data-id': 'edit', ->
  div 'data-role': 'header', ->
    h1 'Edit Project'
  div 'data-role': 'content', ->
    form action: "/projects/#{@project._id}", method: 'post', ->
      div 'data-role': 'fieldcontain', ->
        label for: 'name', -> 'Name'
        input type: 'text', name: 'name', id: 'name', placeholder: 'project name', value: @project.name
        label for: 'description', -> 'Description'
        textarea name: 'description', id: 'description', placeholder: 'description', ->
          @project.description
        label for: 'owner', -> 'Owner'
        input type: 'text', name: 'owner', id: 'owner', placeholder: 'project owner', value: @project.owner
      div 'data-role': 'fieldcontain', ->
        input type: 'submit', value: 'Update'

