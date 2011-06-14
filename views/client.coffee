# Load jQuery from cdn
script src: 'http://code.jquery.com/jquery-1.6.1.min.js'
# Load Handlebars locally, should be on cdn soon :)
script src: '/handlebars.1.0.0.beta.3.js'
# Load Form Params Plug In
script src: '/jquery.formparams.min.js'

coffeescript ->
  # # jQueryMobile Document Ready Handler
  # InOrder to correctly bind to jQuery Mobile Events
  # You need to use the mobileinit event and not the 
  # document ready event.
  $(document).bind 'mobileinit', ->
    # # Disable jQueryMobile ajax
    # we want to control the flow of our application
    # to and from our server.
    $.mobile.ajaxEnabled = false
    # # A simple cache for all of our projects
    # Would like to move this to lawnchair at
    # some point.
    window.models = []
    # # Current Project
    # A global variable to maintain the current project
    # Is this the best way to manage this or is it better
    # to pass it around from view to view?
    #
    # Currently, it seems to be the right approach, again
    # we could add it and the views to an app object then
    # add the app object to the global space.
    window.current_model = null

    # # Views
    # I spent a lot of time digging through backbonejs and spinejs
    # and they add a lot of helper methods to make this process
    # much easier, but I constantly hit points in the development
    # process that would make the implementation more painful.
    # 
    # Also, I wanted to implement by hand just to see what helper
    # methods are actually needed vs not needed.
    #
    # So, I used the coffee-script class syntax to create objects
    # that represent views.  IMO, it turns out using the jQM
    # events, I did not have to implement a lot of the communication
    # hooks implemented in Backbone or Spine to communicate from
    # model to view via controller.
    #
    # In the single page app context it seems that the jQM navigation
    # system works great for routing pages.
    #
    # Also, in the view objects I was able to hook into the jQM
    # evented system and jQM Live function to manage the binding
    # of many events.
    #
    # # LoginView
    class LoginView
      constructor: ->
        # ## PageBeforeShow
        # Bind on the page before show jQM Event to check
        # for authorization, if not authorized then
        # show login page
        # if authorized then go to index page.
        $('#login').live 'pagebeforeshow', ->
          auth = window.localStorage.getItem('authorized')
          if auth? and auth == 'true'
            $.mobile.changePage '#home', 'slideup'

        # ## Login Form Submit
        # Bind to the submit event of the login form element
        # .. be sure to use live method to work with jQM
        # Post to the sessions server url
        # and if successful set authorize to true
        $('#login form').live 'submit', ->
          $.post('/sessions').then (err) ->
            window.localStorage.setItem 'authorized', "true"
            $.mobile.changePage '#home', 'slideup'
          false
    
    # # ProjectHomeView
    #
    class ProjectHomeView
      NEW_BUTTON: '#home a[data-action=new]'
      # ## pageshow
      # get the list of projects
      # and paint them to the home page
      pageshow: (event, ui) ->
        $.getJSON('/projects')
          .then (data) -> 
            window.models = data
            @source ?= $('#project-list').html()
            @template ?= Handlebars.compile(@source)
            html = @template projects: data
            $('#projects-container').html(html)
            $('#projects-container ul').listview()
          .fail (err) ->
            window.localStorage.setItem 'authorized', 'false'
            $.mobile.changePage '#login', 'slidedown'
      # ## show project
      # Find the project from the array of projects
      # set as the current project
      # and change page to show
      show_project: ->
        id = $(this).attr('data-id')
        $.each window.models, (i, prj) ->
          if prj._id == id
            window.current_model = prj
            $.mobile.changePage '#show', 'slideup'

      # ## constructor
      # Bind to page show event 
      # Bind to home button
      # Bind each project li to the show_project method
      constructor: ->
        # -------  Page Home Events -------------------
        $('#home').live 'pageshow', @pageshow
        $(@NEW_BUTTON).live 'click', -> $.mobile.changePage '#new', 'slideup'
        $('#projects-container li a').live 'click', @show_project


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
        $(@NEW_STATUS).live 'click', -> 
          $.mobile.changePage '#status_new', 'pop'
          false

        $(@EDIT_BTN).live 'click', -> 
          $.mobile.changePage '#edit', 'slideup'
          false

        $(@HOME_BTN).live 'click', -> 
          $.mobile.changePage '#home','slidedown'
          false

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
        $(@CANCEL_BTN).live 'click', -> 
          $.mobile.changePage '#show', 'slidedown'
          false

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
    login = new LoginView
    project_home_view = new ProjectHomeView
    project_show_view = new ProjectShowView
    project_new_view = new ProjectNewView
    project_edit_view = new ProjectEditView
    status_new_view = new StatusNewView

    true

script src: 'http://code.jquery.com/mobile/latest/jquery.mobile.min.js'

