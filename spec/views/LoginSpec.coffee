global.window = require('jsdom').jsdom().createWindow();
global.jQuery = require('jquery')

require('../../views/templates.coffee')
# empty.spec.coffee
#input = jQuery('<input />').appendTo('body').placeholder('foo')

describe 'Project Template', ->
  it 'should be true', ->
    expect(input.val()).toEqual('foo')
