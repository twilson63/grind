# _Grind Server Side App_ 
# The purpose of this documentation is to document
# the technology itself vs the nature of the application.

mate = require('coffeemate')
coffeekup = require 'coffeekup'
mongo = require 'mongoskin'
db = mongo.db(process.env.MONGODB_URL || 'localhost:27017/grind')

# MongoSkin makes it super simple to create binded collection
# objects very similar to the class methods of a model in
# an object relational model.
db.bind 'projects'
db.bind 'users'


# helper methods to simplify the code in the web application.
db.projects.update_attributes = (id, data, callback) ->
  @findById id, (err, project) =>
    [project.name, project.description, project.owner] = [data.name, data.description, data.owner]
    @updateById project._id, project, (err) ->
      callback project

db.projects.add_status = (id, status, callback) ->
  @findById id, (err, project) =>
    project.statuses ?= []
    status.id = project.statuses.length + 1
    project.statuses.unshift status
    @updateById project._id, project, (err) ->
      callback project

# Future coffeemate settings once I able to figure out
# the include issues
# ----
mate.options.renderExt = '.coffee'
mate.options.renderDir = 'views'
#mate.coffeekup()
# # bind coffeekup explicitly
mate.options.renderFunc = (tmpl, ctx) ->
  coffeekup.render tmpl, context: ctx



# ## Connect Middleware
#mate.basicAuth process.env.APIKEY, process.env.SECRETKEY if process.env.APIKEY? and process.env.SECRETKEY?
mate.cookieParser()
mate.session secret: 'wilburwonderdog'
mate.logger()
mate.static __dirname + '/public'
mate.bodyParser()

# Custom middleware that validates authentication
mate.use (req, resp, next) ->
  app_url = req.url.match /projects|users/
  if app_url? and not req.session.authenticated?
    resp.writeHead 401, 'Content-Type': 'text'
    resp.end '401 - Not Authorized'
  else
    next()

# Coffeemate Extension that makes it simple to send json back to the client
mate.context.send_json = (data) ->
  @resp.writeHead 200, 'Content-Type': 'application/json'
  @resp.end JSON.stringify data

# Coffeemate Extension that makes it simple to send text back to the client
mate.context.send_text = (data) ->
  @resp.writeHead 200, 'Content-Type': 'text'
  @resp.end data

# Coffeemate router code
mate
  # Get the html markup for the client
  .get '/', ->
    db.projects.find(active: true).toArray (err, items) =>
      @render 'index'

  # Get the projects in json
  .get '/projects', ->
    db.projects.find(active: true).toArray (err, projects) =>
      @send_json projects

  # Create a new project via json
   .post '/projects', ->
    project = @req.body
    project.name = project.name.split(' ').join('-').toLowerCase()
    project.active = true
    db.projects.insert project, (err) =>
      @send_json project

  .put '/projects/:id', ->
    db.projects.update_attributes @req.params.id, @req.body, (project) =>
      @send_json project

  .post '/projects/:id/statuses', ->
    db.projects.findById @req.params.id, (err, project) =>
      db.projects.add_status @req.params.id, @req.body, (project) =>
        @send_json project

  # users
  .post '/users', ->
    if @req.session.isAdmin?
      enc = bcrypt @req.body.password
      user = 
        username: @req.body.username
        email: @req.body.email
        password_hash: enc.hash
        password_xxx: enc.xx
      db.users.insert @req.body, (err, user) ->
        @send_json user
  
  .put '/users/:id', ->
    if @req.session.isAdmin? or @req.session._id is @req.params.id
      db.users.findById @req.params._id, (err, user) ->
        [user.email, user.username] = [@req.body.email, @req.body.username]
        db.users.updateById @req.params_id, user, (err, user) ->
          @send_json user
  
  # sessions
  .post '/sessions', ->
    # bcrypt password
    #db.users.findOne username: @req.body.user, password: bcrypt.hash, (err, user) ->
    #  if err?
    #    @resp.writeHead 401, 'Content-Type': 'text'
    #    @resp.end '401 Authorization Denied'
    #  else
    @req.session.authenticated = true
    @send_text 'ok'



mate.listen process.env.VMC_APP_PORT || 3000

console.log 'listening...'
