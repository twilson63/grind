div 'data-role': 'page', ->
  div 'data-role': 'header', -> 
    h1 'The Grind'
    a href: '#add', -> 'Add Project'
  div 'data-role': 'content', ->
    ul 'data-role': 'listview', ->
      for project in @projects || []
        li ->
          a href: "/projects/#{project.name}", 'data-ajax': false, -> project.name

include 'views/new.coffee'
