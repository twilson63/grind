
fermata = require 'fermata'
api = fermata.api url: 'http://localhost:3000'

describe 'app', ->
  it 'GET /', ->
    api.get (err, result) ->
      console.log err
      console.log result
      asyncSpecDone()
    asyncSpecWait()

