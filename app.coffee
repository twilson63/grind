mongo = require 'mongoskin'
db = mongo.db(process.env.MONGODB_URL || 'localhost:27017/grind')
qs = require 'querystring'
connect = require 'connect'
meryl = require('meryl')
sys = require('sys')

# models
db.bind 'projects'

opts=
  templateDir: 'views'
  port: Number(process.env.VMC_APP_PORT) || 8000

# Setup Template Engine
coffeekup = require 'coffeekup'
opts.templateExt = '.coffee'
opts.templateFunc = coffeekup.adapters.meryl

meryl
  .plug(connect.logger())
  .plug(connect.compiler({ src: 'public', enable: ['coffeescript'] }))
  .plug(connect.static 'public')
  .plug 'POST *', (req, resp, next) ->
    req.body = qs.parse req.postdata.toString()
    next()
  .get '/', (req, resp) ->
    # Get Projects
    db.projects.find(active: true).toArray (err, items) ->
      resp.render 'layout', 
        body: 'index'
        context:
          projects: items
  .post '/projects', (req, resp) ->
    project = req.body
    project.active = true
    db.projects.insert project, (err) ->
      resp.redirect '/'

  # Show Project
  .get '/projects/{name}', (req, resp) ->
    db.projects.findOne name: req.params.name, (err, project) ->
      resp.render 'layout',
        body: 'projects'
        context: project
  .post '/projects/{id}', (req, resp) ->
    db.projects.findById req.params.id, (err, project) ->
      project.name = req.body.name
      project.description = req.body.description
      project.owner = req.body.owner
      db.projects.updateById project._id, project, (err) ->
        resp.redirect "/projects/#{project.name}"
  .post '/projects/{id}/statuses', (req, resp) ->
    db.projects.findById req.params.id, (err, project) ->
      project.statuses ?= []
      project.statuses.push req.body
      db.projects.updateById req.params.id, project, (err) ->
        resp.redirect "/projects/#{project.name}"

  .run opts


