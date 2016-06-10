should  = require 'should'
Wakachi = require '../Wakachi'

describe 'test of `Wakachi`.', ->
    it 'should be a constructor.', ->
        (typeof Wakachi).should.be.exactly 'function'
        (typeof new Wakachi {}).should.be.exactly 'object'

    for method in ['bind', 'unbind']
        it "should have method t`#{method}`.", ->
            wakachi = new Wakachi {}
            (typeof wakachi[method]).should.be.exactly 'function'
