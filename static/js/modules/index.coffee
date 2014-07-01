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
            this.initQuickReply()
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
            $(window).resize ()->
                height = $(window).outerHeight()-120
                width = $('#dialog-list').outerWidth()
                $('#dialog-list').height height
                $('.email-dialog').find('.quick-reply').outerWidth width
        initQuickReply: ()->
            that = this
            $ ()->
                that.computeSize()
                $reply = $('.quick-reply')
                $reply.find('input').focus (e)->
                    $(this).parent().css('bottom','-20px')
                $reply.find('.oper button[name=hide]').click ()->
                    $reply.css 'bottom', '-120px'
                $reply.find('.oper button[name=send]').click ()->
                    title = $reply.find('input').val()
                    content = $reply.find('textarea').val()
                    email = $('.dialog-header').data 'email'
                    if content is ''
                        return
                    dialog ={}
                    dialog.subject = title
                    dialog.type = 'to'
                    dialog.text = content
                    addedDialog = that.addDialog dialog
                    that.clearQuickReply $reply
                    $.ajax
                        url: '/send'
                        dataType: 'json'
                        type: 'post'
                        data:
                            subject: title
                            to: email
                            text: content
                            html: ''
                        success: (data)->
                            console.log data
                        error: (err)->
                            that.dialogView.collection.remove addedDialog
        clearQuickReply: ($reply)->
            $reply.find('input').val ''
            $reply.find('textarea').val ''
            $reply.css 'bottom', '-120px'

        addDialog: (model)->
            return this.dialogView.collection.add model


    new app





