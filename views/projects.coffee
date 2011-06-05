doctype 5
html ->
  head ->
    title 'The Grind'
    meta charset: 'utf-8'
    meta name: 'viewport', content:'width=device-width, minimum-scale=1, maximum-scale=1'

    meta(name: 'description', content: @description) if @description?
    link(rel: 'canonical', href: @canonical) if @canonical?

    link rel: 'icon', href: '/favicon.png'
    link href: 'http://code.jquery.com/mobile/latest/jquery.mobile.min.css', rel: 'stylesheet', type: 'text/css'
    script src: 'http://code.jquery.com/jquery-1.6.1.min.js'
    coffeescript ->
      # Reset new form
      ($ '#add').live 'pagebeforeshow', -> ($ '#add form input, #add form textarea').val('')

    script src: 'http://code.jquery.com/mobile/latest/jquery.mobile.min.js'

  body ->
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
