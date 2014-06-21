define (require, exports, module) ->
    $ = require 'jquery'
    Backbone = require 'backbone'
    ContactsView = require '../views/contactsView'
    app = Backbone.View.extend
        initialize: () ->
            this.contactsView = new ContactsView
            $('.signout a').click this.signout
        signout: (e) ->
            e.preventDefault()
            $.post '/signout',(data) ->
                if data.success
                    document.location.href = '/login'

    new app

