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
    script src: 'http://code.jquery.com/jquery-1.6.1.min.js'
    script src: '/jquery.formparams.min.js'

    coffeescript ->
      $(document).bind 'mobileinit', ->
        $.mobile.ajaxEnabled = false
        window.models = []
        window.current_model = null

        # ---- views
        class ProjectHomeView
          NEW_BUTTON: '#home a[data-action=new]'
          render: (data) ->
            window.models = data
            $('#projects-container').html """
              <ul id="projects-list" data-role="listview" data-insert="true" data-filter="true">
              </ul>
            """
            $.each data, (i, prj) ->
              $('#projects-container ul').append "<li><a href='#' data-id='#{prj._id}'>#{prj.name}</a></li>"
            $('#projects-list').listview()
            $('#projects-list li a').live 'click', @show_project
          pageshow: (event, ui) ->
            $.getJSON('/projects').then (data) -> project_home_view.render data
          show_project: ->
            id = $(this).attr('data-id')
            $.each window.models, (i, prj) ->
              if prj._id == id
                window.current_model = prj
                $.mobile.changePage '#show', 'slideup'
          constructor: ->
            # -------  Page Home Events -------------------
            $('#home').live 'pageshow', @pageshow
            $(@NEW_BUTTON).live 'click', -> $.mobile.changePage '#new', 'slideup'

        class ProjectNewView
          CANCEL_BTN: '#new a[data-action=cancel]'
          pagebeforeshow: (event, ui) ->
            $('#new_name', '#new').val('')
            $('#new_owner', '#new').val('')
            $('#new_description', '#new').val('')
          submit: ->
            prj = $('#new form').formParams()
            ($.ajax
              type: 'POST'
              url: '/projects'
              contentType: 'application/json'
              data: JSON.stringify(prj)).then ->
              $.mobile.changePage '#home', 'slidedown'
            false
          constructor: ->
            $('#new').live 'pagebeforeshow', @pagebeforeshow
            $(@CANCEL_BTN).live 'click', -> $.mobile.changePage '#home', 'slidedown'
            $('#new form').live 'submit', @submit

        class ProjectShowView
          HOME_BTN: '#show a[data-action=home]'
          EDIT_BTN: '#show a[data-action=edit]'
          NEW_STATUS: '#show a[data-action=add_status]'
          pagebeforeshow: (event, ui) ->
            content = '#show div[data-role=content]'
            prj = window.current_model
            $('#show_name', content).html(prj.name)
            $('#owner', content).html(prj.owner)
            $('#description', content).html(prj.description)
          pageshow: (event, ui) ->
            prj = window.current_model
            # Does this need to be a microview???
            $('#status-container', '#show').html """
              <ul id="status-list" data-role="listview" data-insert="true" >
              </ul>
            """
            status_list = $('ul#status-list', '#show div[data-role=content]')
            status_list.empty()
            if prj.statuses?
              $.each prj.statuses, (i, status) ->
                status_list.append "<li>#{status.description}</li>"
              status_list.listview()

          constructor: ->
            # render events
            $('#show').live 'pagebeforeshow', @pagebeforeshow
            $('#show').live 'pageshow', @pageshow
            # bind to events
            $(@NEW_STATUS).live 'click', -> $.mobile.changePage '#status_new', 'pop'
            $(@EDIT_BTN).live 'click', -> $.mobile.changePage '#edit', 'slideup'
            $(@HOME_BTN).live 'click', -> $.mobile.changePage('#home','slidedown')

        class ProjectEditView
          CANCEL_BTN: '#edit a[data-action=cancel]'
          pagebeforeshow: (event, ui) ->
            prj = window.current_model
            $('#edit_name', '#edit').val(prj.name)
            $('#edit_description', '#edit').val(prj.description)
            $('#edit_owner', '#edit').val(prj.owner)
            #$('form', '#edit').attr('action', "/projects/#{prj._id}")

          constructor: ->
            $('#edit').live 'pagebeforeshow', @pagebeforeshow
            $(@CANCEL_BTN).live 'click', -> $.mobile.changePage '#show', 'slidedown'
            # For some reason only works when nested...
            $('#edit form').live 'submit', ->  
              prj = window.current_model
              data = $('#edit form').formParams()
              prj.name = data.name
              prj.description = data.description
              prj.owner = data.owner
              $.ajax
                type: 'PUT'
                url: "/projects/#{prj._id}"
                contentType: 'application/json'
                data: JSON.stringify(prj)
              window.current_model = prj
              $.mobile.changePage '#show', 'slidedown'
              false


        class StatusNewView
          CANCEL_BTN: ''
          pagebeforeshow: (event, ui) ->
            $('#status_new :input').val('')
            $("#status_new texarea").text('')

          constructor: ->
            # bind render events
            $('#status_new').live 'pagebeforeshow', @pagebeforeshow
            # bind dom events
            $(@CANCEL_BTN).live 'click', -> $.mobile.changePage '#show', 'slidedown'
            $("#status_new form").live 'submit', -> 
              prj = window.current_model
              prj.statuses ?= []
              status = $("#status_new form").formParams()
              prj.statuses.unshift status
              window.current_model = prj
              $.ajax
                type: 'POST'
                url: "/projects/#{window.current_model._id}/statuses"
                contentType: 'application/json'
                data: JSON.stringify(status)
              $.mobile.changePage '#show', 'slidedown'
              false


        # ----------- Init Classes -----------------------
        project_home_view = new ProjectHomeView
        project_show_view = new ProjectShowView
        project_new_view = new ProjectNewView
        project_edit_view = new ProjectEditView
        status_new_view = new StatusNewView

        true
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
    include 'views/edit.coffee'
    include 'views/status_new.coffee'

