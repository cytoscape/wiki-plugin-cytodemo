# build time tests for cytodemo plugin
# see http://mochajs.org/

cytodemo = require '../client/cytodemo'
expect = require 'expect.js'

describe 'cytodemo plugin', ->

  describe 'expand', ->

    it 'can make itallic', ->
      result = cytodemo.expand 'hello *world*'
      expect(result).to.be 'hello <i>world</i>'
