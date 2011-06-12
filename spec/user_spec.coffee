jsdom = require 'jsdom'
fermata = require 'fermata'
api = fermata.api url: 'http://localhost:3000'

describe 'User', ->
  it 'POST /users', ->
    user =
      username: 'jackhq'
      password: 'password'
      email: 'xxx@xxx.com'
    api.users.post user, (err, user) ->
      expect(result._id).toBeDefined()
      asyncSpecDone()
    asyncSpecWait()
