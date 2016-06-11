should  = require 'should'
{Wakachi, Chunker} = require '../Wakachi'

describe 'test of `Wakachi`.', ->
    it 'should be a constructor.', ->
        (typeof Wakachi).should.be.exactly 'function'
        (typeof new Wakachi {}).should.be.exactly 'object'

    for method in ['bind', 'unbind']
        it "should have method `#{method}`.", ->
            wakachi = new Wakachi {}
            (typeof wakachi[method]).should.be.exactly 'function'


describe 'test of `Chunker`.', ->
    it 'should be a constructor.', ->
        (typeof Chunker).should.be.exactly 'function'
        (typeof new Chunker {}).should.be.exactly 'object'

    describe 'static methods interfaces.', ->
        for method in ['isPostPositional']
            do (method)->
                it "should have static method `#{method}`.", ->
                    (typeof Chunker[method]).should.be.exactly 'function'

    describe 'dynamic methods interfaces.', ->
        for method in ['chunk']
            do (method)->
                it "should have dynamic method `#{method}`.", ->
                    (typeof new Chunker().chunk).should.be.exactly 'function'


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

    describe 'test of `chunk`.', ->
            cases = [
                {i:['日本語'], o:['日本語'] }
                {i:['日本語','を'], o:['日本語を'] }
                {i:['日本語','を','美しく'], o:['日本語を','美しく']}
                {i:['日本語','を','美しく','表示','する'], o:['日本語を','美しく','表示する']}
                {i:['お得','な','モーニング'], o:['お得な','モーニング']}
                {i:['紹介','します'],o:['紹介します']}
            ]
            for c in cases
                do (c)->
                    it "should chunk '#{c.i}' as '#{c.o}'.", ->
                        chunks = new Chunker(c.i).chunk()
                        console.log chunks
                        chunks.length.should.be.exactly c.o.length
                        for i in [0...chunks.length]
                            chunks[i].should.be.exactly c.o[i]
