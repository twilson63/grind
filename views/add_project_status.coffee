div 'data-role': 'page', id: 'add-status', 'data-id': 'add-status',  ->
  div 'data-role': 'header', -> 
    h1 'Update Status'
  div 'data-role': 'content', ->
    form action: "/projects/#{@project._id}/statuses", method: 'post', ->
      div 'data-role': 'fieldcontain', ->
        label for: 'description', -> 'Description'
        textarea name: 'description', id: 'description', placeholder: 'status details'
        label for: 'stakeholder', -> 'Stakeholder'
        input type: 'text', name: 'stakeholder', placeholder: 'from stakeholder', id: 'stakeholder'
        label for: 'report_date', -> 'Report Date'
        input type: 'date', name: 'report_date', placeholder: 'date reported', id: 'report_date'
      div 'data-role': 'fieldcontain', ->
        input type: 'submit', value: 'Update Project Status'


