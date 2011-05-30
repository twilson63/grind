mongo = require 'mongoskin'
exports.projects = (db = 'localhost:27017/grind') ->
  mongo.db(db).collection('projects')

# class Project
#   VERSION: '0.0.1'
#   constructor: (db = 'localhost:27017/grind', collection_name = 'projects') ->
#     # Init MongoDb
#     @db = mongo.db(db)
#     @projects = @db.collection(collection_name)

#   add: (project, callback) ->
#     @projects.insert project, (err) ->
#       callback()

#   all: (callback) ->
#     @projects.find {}, (err, projects) ->
#       callback projects

#   update: (project_name, update_attributes, callback) ->
#     @projects.findOne {name: project_name}, (err, project) =>
#       if project
#         project = update_attributes
#         @projects.updateById project._id, project, (err) ->
#           xxx
#   find: (project_name, callback) ->
#     callback()
#   update_status: (project_name, status_update, callback) ->
#     callback()

# function merge_options(obj1,obj2){
#     var obj3 = {};
#     for (attrname in obj1) { obj3[attrname] = obj1[attrname]; }
#     for (attrname in obj2) { obj3[attrname] = obj2[attrname]; }
#     return obj3;
# }

# exports.project = new Project
