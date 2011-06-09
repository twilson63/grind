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
      $(document).bind 'mobileinit', ->
        $.mobile.ajaxEnabled = false
        console.log 'Ready'
        window.models = []
        window.current_model = null

        project_home_view =
          render: ->
            $.mobile.changePage('#home','slidedown')

        project_new_view =
          render: ->
            $('#new_name', '#show').val('')
            $('#new_owner', '#new').val('')
            $('#new_description', '#new').val('')
            $.mobile.changePage('#new','slideup')
          save: ->
            prj =
              name: $('#new_name', '#show').val()
              description: $('#new_description', '#new').val()
              owner: $('#new_owner', '#new').val()
            ($.postJSON '/projects', prj).then (data) ->
              project_home_view.render()

        project_show_view = 
          render: ->
            prj = window.current_model
            $('#show_name', '#show div[data-role=content]').html(prj.name)
            $('#owner', '#show div[data-role=content]').html(prj.owner)
            $('#description', '#show div[data-role=content]').html(prj.description)
            if prj.statuses?
              $.each prj.statuses, (i, status) ->
                $('ul', '#show div[data-role=content]').append "<li>#{status.description}</li>"
            $.mobile.changePage('#show','slideup')

        project_edit_view =
          render: ->
            prj = window.current_model
            $('#edit_name', '#edit').val(prj.name)
            $('#edit_description', '#edit').val(prj.description)
            $('#edit_owner', '#edit').val(prj.owner)
            $('form', '#edit').attr('href', "/projects/#{prj._id}")
            $.mobile.changePage('#edit','slideup')
          save: ->
            prj = window.current_model
            prj.name = $('#edit_name', '#edit').val()
            prj.description = $('#edit_description', '#edit').val()
            prj.owner = $('#edit_owner', '#edit').val()

            ($.ajax
              type: 'PUT'
              url: "/projects/#{prj._id}"
              contentType: 'application/json'
              data: JSON.stringify(prj)).then (project) ->
              alert 'saved'
              console.log project

        $('#home').live 'pageshow', (event, ui) ->
          $('#projects-container').html """
            <ul id="projects-list" data-role="listview" data-insert="true" data-filter="true">
            </ul>
          """
          $.getJSON('/projects').then (data) ->
            window.models = data
            $.each data, (i, prj) ->
              $('#projects-container ul').append "<li><a href='#' data-id='#{prj._id}'>#{prj.name}</a></li>"
            $('#projects-list').listview()

        $('#home a[data-action=new]').live 'click', ->
          project_new_view.render()
          return false
        
        $('#projects-container a').live 'click', ->
          id = $(this).attr('data-id')
          $.each window.models, (i, prj) ->
            if prj._id == id
              window.current_model = prj
              project_show_view.render()
          return false

        $('#show a[data-action=edit]').live 'click', ->
          project_edit_view.render()
          return false

        $('#show a[data-action=home]').live 'click', ->
          project_home_view.render()
          return false

        $('#edit a[data-action=cancel]').live 'click', ->
          project_show_view.render()
          return false

        $('#edit form').live 'submit', ->
          # write data to current model
          project_edit_view.save()
          return false

        $('#new a[data-action=cancel]').live 'click', ->
          project_home_view.render()
          return false
        $('#new form').live 'submit', ->
          project_new_view.save()
          project_home_view.render()
          return false

    script src: 'http://code.jquery.com/mobile/latest/jquery.mobile.min.js'
  body ->
    div id: 'home', 'data-role': 'page', ->
      div 'data-role': 'header', ->
        h1 'The Grind'
        a href: '#', 'data-action': 'new', -> 'Add'
      div 'data-role': 'content', ->
        span id: 'projects-container', ->
          "Loading Please Wait..."

    include 'views/new.coffee'
    include 'views/show.coffee'
    include 'views/edit_project.coffee'
    #include 'views/add_project_status.coffee'
