should  = require 'should'
Wakachi = require '../Wakachi'

describe 'test of `Wakachi`.', ->
    it 'should be a constructor.', ->
        (typeof Wakachi).should.be.exactly 'function'
        (typeof new Wakachi {}).should.be.exactly 'object'

    it 'should save the arguments when construction.', ->
        wakachi = new Wakachi {}
        (typeof wakachi.selector).should.be.exactly 'string'
