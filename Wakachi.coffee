'use strict'

# Main object
class Wakachi

  _segmenter: null
  _selector:  null
  _events:    null

  constructor: (options) ->
    # try to import dependency
    TinySegmenter = require './TinySegmenter.js'

    _segmenter = new TinySegmenter()
    # options default
    unless options then options = {}
    unless options.elements? then options.elements = [
        '[wakachi]',
        '[data-wakachi]'
    ]
    unless options.events? then options.events = ['click']#'load','resize'
    # normalize the fields for jQuery
    _selector = options.elements.join ','
    _events   = options.events.join ' '

  # Refresh line feeding point when parent is resized.
  # コンテナがリサイズされたときに、改行点をリフレッシュします。
  wakachi = (event) ->
    $(this._selector).each ->
      text = $(this).text()
      $(this).text ''
      segs = _segmenter.segment text
      prevHeight = -1
      walker = 0

      for seg in segs
        r = Math.round(Math.random() * 256)
        g = Math.round(Math.random() * 256)
        b = Math.round(Math.random() * 256)
        element = $ "<span style=\"color:rgb(#{r},#{g},#{b})\">#{seg}</span>"
          .appendTo $(this)
        if 0 < prevHeight and prevHeight < element.height()
          element.before $ '<br />'
        else
          prevHeight = element.height()

  # Remove listener from the container
  unbind: (container)->
    # Detach event handler
    $(container).off this._events, this._selector, wakachi
    return this

  # Bind listener to the container
  bind: (container)->
    unless container? then container = $ this._selector
    # turn into  jquery object if needed
    unless (container instanceof $) then container = $ container
    # clean up at first
    if container? then this.unbind()
    # Attach event handler
    $(this).on this._events, this._selector, wakachi

    wakachi()
    return this
# ------------------------------------------------------------------- Wakachi --

# Chunker ----------------------------------------------------------------------
class Chunker
  @postPositionals: [
    # 格助詞
    'が', 'の', 'を', 'に', 'へ', 'と', 'から', 'より', 'で', 'や'
    # 並立助詞
    'の', 'に', 'と', 'や', 'やら', 'か', 'なり', 'だの'
    # 副助詞
    'ばかり', 'まで', 'だけ', 'ほど', 'くらい', 'など', 'なり', 'やら'
    # 係助詞
    'は', 'も', 'こそ', 'でも', 'しか', 'さえ', 'だに'
    # 接続助詞
    'ば', 'と', 'ても', 'けれど', 'が', 'のに', 'ので', 'から', 'し', 'て', 'で', 'なり',
    'ながら', 'たり', 'つつ'
    # 終助詞
    'か', 'な', 'とも', 'ぞ', 'や'
    # 女性言葉
    'わ', 'こと', 'てよ', 'ことよ', 'もの', 'かしら'
    # 間投助詞
    'さ', 'よ', 'ね', 'な', 'の'
    # その他（助詞意外）
    'する','し','します'
    #
    'です'
  ]

  _words: null
  @_isArray: (obj)->
    if Array.isArray?
      Array.isArray obj
    else
      # fall back for browers which do not support ES6
      Object.prototype.toString.call(obj) is '[object Array]'

  constructor: (words)-> this._words = words

  @getPostPositionals: -> @postPositionals

  @addPostPositionals: (additionals)->
    if ! (typeof additionals is 'string') and ! (@_isArray additionals)
      throw new Error 'Only strings or arrays are acceptable.'
    else if (additionals is '') or (@_isArray additionals and additionals.length is 0)
      throw new Error 'Empty string or array are not acceptable.'
    @postPositionals.push additionals
    # method chain
    return Chunker

  @removePostPositionals: (removals) ->
    if ! (typeof removals is 'string') and ! (@_isArray removals)
      throw new Error 'Only strings or arrays are acceptable.'
    else if (removals is '') or (@_isArray removals and removals.length is 0)
      throw new Error 'Empty string or array are not acceptable.'

    for pp, i in @postPositionals
      if pp is removals then delete @postPositionals[i]
    # method chain
    return Chunker

  @isPostPositional: (word)->
    word in @postPositionals

  chunk: ->
    chunk = ''
    postPositionalContinues = false
    result = []

    for word in this._words
      if postPositionalContinues
        if Chunker.isPostPositional word
          chunk += word
        else
          postPositionalContinues = false
          result.push chunk
          chunk = word
      else
        if Chunker.isPostPositional word
          chunk += word
          postPositionalContinues = true
        else
          if chunk isnt ''
            result.push chunk
          chunk = word

    if chunk isnt '' then result.push chunk

    return result

# module export
module.exports = {Wakachi, Chunker}

# jQuery plugin
if window? && window.jQuery
  $.fn.wakachi = (options) ->
    wakachi = new Wakachi options
    wakachi.bind()
    return wakachi.mainContainer # method chain
  $.fn.wakachi()
