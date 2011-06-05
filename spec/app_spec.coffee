tobi = require 'tobi'
app = require '../app.coffee'
browser = tobi.createBrowser(8000,'localhost')
#browser = tobi.createBrowser(app)

describe 'app', ->
  it 'be valid', ->
    browser.get '/', (res, $) ->
      (expect $('body').html().match(/The Grind/)[0]).toEqual 'The Grind'
      #(expect res.status).toEqual 200
      asyncSpecDone()
    asyncSpecWait()
    app.close()

