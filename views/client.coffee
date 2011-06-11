script src: 'http://code.jquery.com/jquery-1.6.1.min.js'
script src: '/handlebars.1.0.0.beta.3.js'
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
        @source ?= $('#project-list').html()
        @template ?= Handlebars.compile(@source)
        html = @template projects: data
        $('#projects-container').html(html)
        $('#projects-container ul').listview()
        $('#projects-container li a').live 'click', @show_project

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
        @source ?= $('#show-content').html()
        @template ?= Handlebars.compile(@source)
        html = @template(window.current_model)
        $('#show').html(html)
        $('#show div').page()

      constructor: ->
        # render events
        $('#show').live 'pagebeforeshow', @pagebeforeshow
        # bind to events
        $(@NEW_STATUS).live 'click', -> $.mobile.changePage '#status_new', 'pop'
        $(@EDIT_BTN).live 'click', -> $.mobile.changePage '#edit', 'slideup'
        $(@HOME_BTN).live 'click', -> $.mobile.changePage('#home','slidedown')

    class ProjectEditView
      CANCEL_BTN: '#edit a[data-action=cancel]'
      pagebeforeshow: (event, ui) ->
        @source ?= $('#edit-form').html()
        @template ?= Handlebars.compile(@source)
        html = @template(window.current_model)
        $('#edit-form-container').html(html)
        $('#edit form').page()

      constructor: ->
        $('#edit').live 'pagebeforeshow', @pagebeforeshow
        $(@CANCEL_BTN).live 'click', -> $.mobile.changePage '#show', 'slidedown'
        # For some reason only works when nested...
        $('#edit form').live 'submit', ->  
          prj = window.current_model
          data = $('#edit form').formParams()
          [prj.name, prj.description, prj.owner] = [data.name, data.description, data.owner]
          $.ajax type: 'PUT', url: "/projects/#{prj._id}", contentType: 'application/json', data: JSON.stringify(prj)
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
          $.ajax type: 'POST', url: "/projects/#{window.current_model._id}/statuses", contentType: 'application/json', data: JSON.stringify(status)
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

