'use strict'

# try to import jQuery
if ! jQuery? and require? and (typeof require is 'function')
        jQuery = require 'jQuery'

# Main object
class Wakachi
    constructor: (options) ->

        $ = jQuery
        @mainContainer = null
        # options default
        unless options.elements? then options.elements = ['[wakachi]','[data-wakachi]']
        unless options.events?   then options.events   = ['load','resize']

        @selector = options.elements.join ','
        @events   = options.events.join ' '

    # Fetch targeted elements on the page
    @getTargetedElements = -> @mainContainer.find(@selector)

    # Refresh line feeding point when parent is resized.
    # コンテナがリサイズらさたときに、改行点をリフレッシュします。
    @onResize = (event)->
        # ここに処理を記入
        alert 'start handling'



    # Remove listener from the container
    @unbind = ->
        # Detach event handler
        if @mainContainer? then @mainContainer.off @events, @selector, @onResize
        return self

    # Bind listener to the container
    @bind = (container)->
        # turn into  jquery object if needed
        unless (obj instanceof jQuery) then container = $ container
        # clean up at first
        if container? then @unbind()
        # Store container
        @mainContainer = container
        # Attach event handler
        @mainContainer.on @events, @selector, @onResize
        return self



isAMD =      (typeof define is 'function') and (typeof define.amd is 'object') and define.amd
isCommonJS = (typeof module isnt 'undefined') and module.exports

if isAMD
    define -> Wakachi
else if isCommonJS
    module.exports = Wakachi

# Export to window
else if window?
    window.Wakachi = Wakachi

    # jQuery plugin
    $.fn.wakachi = (options)->
        # Create and bind new instance
        obj = new Wakachi options
        obj.bind this
        # Allow jQuery chaining
        return obj.mainContainer
