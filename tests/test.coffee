should  = require 'should'
{Wakachi, Chunker} = require '../Wakachi'

describe 'test of `Wakachi`.', ->
    it 'should be a constructor.', ->
        Wakachi.should.be.a.Function()

    # interfaces
    for method in ['bind', 'unbind']
        do (method)->
            it "should have dynamic method `#{method}`.", ->
                (new Wakachi {})[method].should.be.a.Function()


describe 'test of `Chunker`.', ->
    it 'should be a constructor.', ->
        Chunker.should.be.a.Function()

    # utilities
    before ->
        describe 'Utility `_isArary`.', ->
            it 'should exists.', ->
                Chunker._isArray.should.be.a.Function()

            it 'should work in ES6.', ->
                Chunker._isArray(['a','b']).should.be.true()

            it 'should work without Array.isArray', ->
                buf = Array.isArray
                Array.isArray = null
                Chunker._isArray(['a','b']).should.be.true()
                Array.isArray = buf

    # interfaces
    describe 'static Methods', ->
        for method in [
            'getPostPositionals'
            'addPostPositionals'
            'removePostPositionals'
            'isPostPositional'
        ]
            do (method)->
                it "should have appropriate static property of #{method}.", ->
                    Chunker[method].should.be.a.Function()

        for method in ['addPostPositionals', 'removePostPositionals']
            do (method)->
                it "should have method chain.", ->
                    Chunker[method]('dummyArg').should.be.exactly Chunker

        # implementation details
        describe 'test of getPostPositionals', ->
            it 'should return array', ->
                Chunker.getPostPositionals().should.be.an.Array()
            it 'should return what should be contained', ->
                Chunker.getPostPositionals().should.containDeep ['て','に','を','は']

        describe 'test of addPostPositionals', ->
            it 'should add new sigle postPositional.', ->
                dummy = 'dummyPostPositional'
                # check in not contained first
                Chunker.getPostPositionals().should.not.containEql dummy
                Chunker.addPostPositionals dummy
                Chunker.getPostPositionals().should.containEql dummy

        describe 'test of removePostPositionals', ->
            it 'should remove a certain postPositional.', ->
                dummy = 'dummyPostPositionaltoRemove'
                Chunker.getPostPositionals().should.not.containEql dummy
                Chunker.addPostPositionals dummy
                Chunker.getPostPositionals().should.containEql dummy
                Chunker.removePostPositionals dummy
                Chunker.getPostPositionals().should.not.containEql dummy

        describe 'test of `isPostPositional`.', ->
            describe 'case true.', ->
                for pp in ['て','に','を','は','する']
                    do (pp)->
                        it "should return correct answer for #{pp}", ->
                            Chunker.isPostPositional(pp).should.be.true()

            describe 'case false.', ->
                for npp in ['日本語','美しく','改行','jQuery', 'プラグイン']
                    do (npp)->
                        it "should return correct answer for #{npp}", ->
                            Chunker.isPostPositional(npp).should.be.false()

            describe 'case error.', ->
                for epp in [0,1,-1,.1,/^aaa$/g,(->return),'',null,undefined,true,false,[],['aaa'],{},{'a':'b'}]
                    do (epp)->
                        it "should return false for #{epp}", ->
                            Chunker.isPostPositional(epp).should.be.false()

    describe 'dynamic methods', ->
        for method in ['chunk']
            do (method)->
                it "should have dynamic method `#{method}`.", ->
                    (new Chunker().chunk).should.be.a.Function()


    #
    # describe 'test of `chunk`.', ->
    #         cases = [
    #             {i:['日本語'], o:['日本語'] }
    #             {i:['日本語','を'], o:['日本語を'] }
    #             {i:['日本語','を','美しく'], o:['日本語を','美しく']}
    #             {i:['日本語','を','美しく','表示','する'], o:['日本語を','美しく','表示する']}
    #             {i:['お得','な','モーニング'], o:['お得な','モーニング']}
    #             {i:['紹介','します'],o:['紹介します']}
    #         ]
    #         for c in cases
    #             do (c)->
    #                 it "should chunk '#{c.i}' as '#{c.o}'.", ->
    #                     chunks = new Chunker(c.i).chunk()
    #                     console.log chunks
    #                     chunks.length.should.be.exactly c.o.length
    #                     for i in [0...chunks.length]
    #                         chunks[i].should.be.exactly c.o[i]
