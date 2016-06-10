should  = require 'should'
Wakachi = require '../Wakachi'

describe 'test of `Wakachi`.', ->
    it 'should be a constructor.', ->
        (typeof Wakachi).should.be.exactly 'function'
        (typeof new Wakachi {}).should.be.exactly 'object'
