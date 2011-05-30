describe 'project', ->
  beforeEach ->
    @projects = require('../models/project').projects('localhost:27017/grind_test')
   
  it 'should return all projects', ->
    @projects.remove (err) =>
      @projects.insert name: 'foobar', active: true, (err) =>
        @projects.find(active: true).toArray (err, items) =>
          expect(items.length).toEqual 1
          asyncSpecDone()
    asyncSpecWait()

  it 'should insert a project', ->
    project =
      name: 'eirenerx-backoffice-phase-1'
      description: 'Refine Eirenerx to pharmacy process'
      owner: 'tnw'
      active: true
    @projects.remove (err) =>
      @projects.insert project, (err) =>
        @projects.find(name: 'eirenerx-backoffice-phase-1').toArray (err, items) =>
          expect(items.length).toEqual 1

  #it 'should update a project'
#@projects.findItems (items) ->
    #  console.log require('sys').inspect items
    #  asyncSpecDone()
    #asyncSpecWait()
  # it 'version should be 0.0.1', ->
  #   expect(@project.VERSION).toEqual('0.0.1')
  # it 'create a project', ->
  #   erx = 
  #     name: 'eirenerx'
  #     description: 'My Description'
  #     owner: 'tnw'
  #   @project.add erx, (err) ->
  #     console.log 'Added Project'
      
  # it 'list projects', -> expect(@project.all.count).toEqual 1
  # it 'update project', ->
  #   @project.update 'eirenerx', data, (err) ->
  #     console.log 'Updated Project'
  # it 'update project status', ->
  #   @project.update_status 'name', 'status update'


