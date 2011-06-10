mate = require('coffeemate')

mongo = require 'mongoskin'
db = mongo.db(process.env.MONGODB_URL || 'localhost:27017/grind')

# models
db.bind 'projects'
db.projects.update_attributes = (id, data, callback) ->
  @findById id, (err, project) =>
    project.name = data.name
    project.description = data.description
    project.owner = data.owner
    @updateById project._id, project, (err) ->
      callback project
db.projects.add_status = (id, status, callback) ->
  @findById id, (err, project) =>
    project.statuses ?= []
    project.statuses.unshift status
    @updateById project._id, project, (err) ->
      callback project

mate.basicAuth process.env.APIKEY, process.env.SECRETKEY if process.env.APIKEY? and process.env.SECRETKEY?
mate.logger()
mate.static __dirname + '/public'
mate.bodyParser()

#mate.context.view = (view)->
#  @view = "views/#{view}.coffee"
#  @render "views/layout.coffee"
  
mate
  .get '/', ->
    db.projects.find(active: true).toArray (err, items) =>
      @render 'views/index.coffee'

  .get '/projects', ->
    db.projects.find(active: true).toArray (err, projects) =>
      @resp.writeHead 200, 'Content-Type': 'application/json'
      @resp.end JSON.stringify projects

  .post '/projects', ->
    project = @req.body
    project.name = project.name.split(' ').join('-').toLowerCase()
    project.active = true
    db.projects.insert project, (err) =>
      @resp.end JSON.stringify project

  .put '/projects/:id', ->
    db.projects.update_attributes @req.params.id, @req.body, (project) =>
      @resp.end JSON.stringify project

  .post '/projects/:id/statuses', ->
    db.projects.findById @req.params.id, (err, project) =>
      db.projects.add_status @req.params.id, @req.body, (project) =>
        @resp.end JSON.stringify project

#  .listen process.env.VMC_APP_PORT || 3000
mate.listen 3000
