doctype 5
html ->
  head ->
    title 'The Grind'
    meta charset: 'utf-8'
    meta name: 'viewport', content:'width=device-width, minimum-scale=1, maximum-scale=1'

    meta(name: 'description', content: @description) if @description?
    meta name: 'apple-mobile-web-app-capable', content: 'yes'
    link(rel: 'canonical', href: @canonical) if @canonical?

    link rel: 'icon', href: '/favicon.png'
    link href: 'http://code.jquery.com/mobile/latest/jquery.mobile.min.css', rel: 'stylesheet', type: 'text/css'
    include 'views/templates.coffee'
    include 'views/client.coffee'

  body ->
    include 'views/login.coffee'
    include 'views/home.coffee'
    include 'views/new.coffee'
    include 'views/show.coffee'
    include 'views/edit.coffee'
    include 'views/status_new.coffee'

