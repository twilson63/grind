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
    include @view