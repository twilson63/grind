mongo = require 'mongoskin'
db = mongo.db(process.env.MONGODB_URL || 'localhost:27017/grind')

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

exports.projects = db.projects
