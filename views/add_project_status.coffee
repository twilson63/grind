div 'data-role': 'page', id: 'add_status', 'data-id': 'add_status',  ->
  div 'data-role': 'header', -> 
    h1 'Update Status'
  div 'data-role': 'content', ->
    form action: "/projects", method: 'post', ->
      div 'data-role': 'fieldcontain', ->
        label for: 'status_description', -> 'Description'
        textarea name: 'description', id: 'status_description', placeholder: 'status details'
        label for: 'status_stakeholder', -> 'Stakeholder'
        input type: 'text', name: 'stakeholder', placeholder: 'from stakeholder', id: 'status_stakeholder'
        label for: 'status_report_date', -> 'Report Date'
        input type: 'date', name: 'report_date', placeholder: 'date reported', id: 'status_report_date'
      div 'data-role': 'fieldcontain', ->
        input type: 'submit', value: 'Update Project Status'
        a href: '#show', 'data-role': 'button', -> 'Cancel'


