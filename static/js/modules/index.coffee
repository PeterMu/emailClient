define (require, exports, module) ->
    $ = require 'jquery'
    Backbone = require 'backbone'
    ContactsView = require '../views/contactsView'
    DialogView = require '../views/dialogView'
    _ = require 'underscore'
    app = Backbone.View.extend
        initialize: () ->
            that = this
            this.contactsView = new ContactsView
            this.dialogView = new DialogView
            $('.signout a').click this.signout
            this.contactsView.collection.on 'loadDialog',(address)->
                that.dialogView.trigger 'loadDialog', address
            $ ()->
                that.computeSize()
                $('.quick-reply input').focus (e)->
                    $(this).parent().css('bottom','-20px')
        signout: (e) ->
            e.preventDefault()
            $.post '/signout',(data) ->
                if data.success
                    document.location.href = '/login'
        computeSize: () ->
            height = $(window).outerHeight() - 120
            width = $('#dialog-list').outerWidth()
            $('#dialog-list').height height
            $('.email-dialog').find('.quick-reply').outerWidth width
            console.log width
            $(window).resize ()->
                height = $(window).outerHeight()-120
                width = $('#dialog-list').outerWidth()
                $('#dialog-list').height height
                $('.email-dialog').find('.quick-reply').outerWidth width
    new app

