div id: 'home', 'data-role': 'page', ->
  div 'data-role': 'header', ->
    h1 'The Grind'
    a href: '#', 'data-action': 'new', -> 'Add'
  div 'data-role': 'content', ->
    span id: 'projects-container', ->
      "Loading Please Wait..."


