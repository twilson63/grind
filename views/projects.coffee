div 'data-role': 'page', ->
  div 'data-role': 'header', ->
    a href: '/', 'data-ajax': false, -> 'Projects'
    a href: '#edit', 'data-rel': 'dialog', -> 'Edit'
    h1 "The Grind"

  div 'data-role': 'content', ->
    ul 'data-role': 'listview', ->
      li 'data-role': 'list-divider', -> 'Name'
      li -> @name
      li 'data-role': 'list-divider', -> 'Owner'
      li -> @owner
      li 'data-role': 'list-divider', -> 'Description'
      li -> @description
      li 'data-role': 'list-divider', -> 'Timeline'
      for status in @statuses || []
        li ->
          h4 status.stakeholder || 'unknown'
          p status.description || 'N/A'
          p status.report_date || 'unknown'
      li ->
        a href: '#add-status', 'data-rel': 'dialog', -> 'Add Status'
div 'data-role': 'page', id: 'add-status', 'data-id': 'add-status',  ->
  div 'data-role': 'header', -> 
    h1 'Update Status'
  div 'data-role': 'content', ->
    form action: "/projects/#{@_id}/statuses", method: 'post', ->
      div 'data-role': 'fieldcontain', ->
        label for: 'description', -> 'Description'
        textarea name: 'description', id: 'description', placeholder: 'status details'
        label for: 'stakeholder', -> 'Stakeholder'
        input type: 'text', name: 'stakeholder', placeholder: 'from stakeholder', id: 'stakeholder'
        label for: 'report_date', -> 'Report Date'
        input type: 'date', name: 'report_date', placeholder: 'date reported', id: 'report_date'
      div 'data-role': 'fieldcontain', ->
        input type: 'submit', value: 'Update Project Status'

div 'data-role': 'page', id: 'edit', 'data-id': 'edit', ->
  div 'data-role': 'header', ->
    h1 'Edit Project'
  div 'data-role': 'content', ->
    form action: "/projects/#{@_id}", method: 'post', ->
      div 'data-role': 'fieldcontain', ->
        label for: 'name', -> 'Name'
        input type: 'text', name: 'name', id: 'name', placeholder: 'project name', value: @name
        label for: 'description', -> 'Description'
        textarea name: 'description', id: 'description', placeholder: 'description', ->
          @description
        label for: 'owner', -> 'Owner'
        input type: 'text', name: 'owner', id: 'owner', placeholder: 'project owner', value: @owner
      div 'data-role': 'fieldcontain', ->
        input type: 'submit', value: 'Update'
 
