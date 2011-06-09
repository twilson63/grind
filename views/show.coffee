div id: 'show', 'data-role': 'page', ->
  div 'data-role': 'header', ->
    a href: '#', 'data-action': 'home', -> 'Projects'
    a href: '#', 'data-action': 'edit', -> 'Edit'
    h1 "The Grind"

  div 'data-role': 'content', ->
    ul 'data-role': 'listview', ->
      li 'data-role': 'list-divider', -> 'Name'
      li id: 'show_name'
      li 'data-role': 'list-divider', -> 'Owner'
      li id: 'owner'
      li 'data-role': 'list-divider', -> 'Description'
      li id: 'description'
      li 'data-role': 'list-divider', -> 'Timeline'
      li ->
        a href: '#add-status', 'data-rel': 'dialog', -> 'Add Status'
      #for status in @project.statuses || []
      #  li ->
      #    h4 status.stakeholder || 'unknown'
      #    p status.description || 'N/A'
      #    p status.report_date || 'unknown'

