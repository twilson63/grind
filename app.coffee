mongo = require 'mongoskin'
db = mongo.db(process.env.MONGODB_URL || 'localhost:27017/grind')
qs = require 'querystring'
mate = require('coffeemate')
sys = require('sys')

# models
db.bind 'projects'
db.projects.update_attributes = (id, data, callback) ->
  @findById id, (err, project) ->
    project.name = data.name
    project.description = data.description
    project.owner = data.owner
    @updateById project._id, project, (err) ->
      callback project
db.projects.add_status = (id, status, callback) ->
  @findById id, (err, project) ->
    project.statuses ?= []
    project.statuses.unshift status
    @updateById project._id, project, (err) ->
      callback project

mate.basicAuth process.env.APIKEY, process.env.SECRETKEY if process.env.APIKEY? and process.env.SECRETKEY?
mate.logger()
mate.static __dirname + 'public'

mate
  .get '/', ->
    # Get Projects
    db.projects.find(active: true).toArray (err, items) ->
      @projects = items
      @render 'index.coffeekup'

  .post '/projects', ->
    project = qs.parse req.postdata.toString()
    project.name = project.name.split(' ').join('-').toLowerCase()
    project.active = true
    db.projects.insert project, (err) ->
      @redirect '/'
  .get '/projects/:id', ->
    db.projects.findOne name: @req.params.name, (err, project) ->
      @render 'projects.coffeekup'
  .post '/projects/:id', ->
    data = qs.parse @req.postdata.toString()
    db.projects.update_attributes @req.params.id, data, (project) ->
      @redirect "/projects/#{project.name}"

  .post '/projects/:id/statuses', ->
    db.projects.findById @req.params.id, (err, project) ->
      status = qs.parse @req.postdata.toString()
      db.projects.add_status @req.params.id, status, (project) ->
        @redirect "/projects/#{project.name}"


  .listen 8000

