div 'data-role': 'page', ->
  div 'data-role': 'header', ->
    a href: '/', 'data-ajax': false, -> 'Projects'
    a href: '#edit', 'data-rel': 'dialog', -> 'Edit'
    h1 "The Grind"

  div 'data-role': 'content', ->
    ul 'data-role': 'listview', ->
      li 'data-role': 'list-divider', -> 'Name'
      li -> @project.name
      li 'data-role': 'list-divider', -> 'Owner'
      li -> @project.owner
      li 'data-role': 'list-divider', -> 'Description'
      li -> @project.description
      li 'data-role': 'list-divider', -> 'Timeline'
      li ->
        a href: '#add-status', 'data-rel': 'dialog', -> 'Add Status'
      for status in @project.statuses || []
        li ->
          h4 status.stakeholder || 'unknown'
          p status.description || 'N/A'
          p status.report_date || 'unknown'

include 'views/edit_project.coffee'
include 'views/add_project_status.coffee'
