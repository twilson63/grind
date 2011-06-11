jsdom = require 'jsdom'
fermata = require 'fermata'
api = fermata.api url: 'http://localhost:3000'

describe 'app', ->
  it 'GET /', ->
    api.get (err, result) ->
      jsdom.env result, [ 'http://code.jquery.com/jquery-1.6.1.min.js'], (err, window) ->
        expect(window.$('#home h1').text()).toEqual('The Grind')
        asyncSpecDone()
    asyncSpecWait()
  it 'GET /projects', ->
    api.projects.get (err, result) ->
      expect(result.length).toBeGreaterThan(0)
      asyncSpecDone()
    asyncSpecWait()
  it 'POST /projects', ->
    new_prj =
      name: 'Hello World'
    api.projects.post new_prj, (err, result) ->
      expect(result._id).toBeDefined()
      asyncSpecDone()
    asyncSpecWait()
  it 'POST /projects/:id/statuses', ->
    new_prj = 
      name: 'status'
    api.projects.post new_prj, (err, result) ->
      status = name: 'update me'
      api.projects[result._id].statuses.post status, (err, result) ->
        console.log result
        expect(result.statuses[0].id).toEqual(1)

        asyncSpecDone()
    asyncSpecWait()

