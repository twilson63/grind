zombie = require 'zombie'

site = "http://localhost:8000"

describe 'app', ->
  # describe 'index', ->
  #   it 'be valid', ->
  #     zombie.visit site, (err, browser, status) ->
  #       (expect status).toEqual 200
  #       asyncSpecDone()
  #     asyncSpecWait()
  describe 'new', ->
    it 'should create project', ->
      zombie.visit site, (err, browser, status) ->
        browser.clickLink "Add Project", (err, browser, status) ->
          browser.fill "Name", "Super Project"
          browser.fill "Description", "Zombie Cool"
          browser.fill "Owner", "Johnny"
          browser.pressButton "Create", (err, browser, status) ->
            console.log browser.html()
            (expect browser.html().match(/super-project/).length).toEqual 1
            asyncSpecDone()
      asyncSpecWait()
