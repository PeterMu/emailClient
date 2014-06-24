define (require, exports, module) ->
    $ = require 'jquery'
    Backbone = require 'backbone'
    ContactsView = require '../views/contactsView'
    DialogView = require '../views/dialogView'
    app = Backbone.View.extend
        initialize: () ->
            this.contactsView = new ContactsView
            this.dialogView = new DialogView
            this.dialogView.pullData 'from', 'mutiezhai@gmail.com'
            $('.signout a').click this.signout
        signout: (e) ->
            e.preventDefault()
            $.post '/signout',(data) ->
                if data.success
                    document.location.href = '/login'

    new app

