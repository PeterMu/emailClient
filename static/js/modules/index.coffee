define (require, exports, module) ->
    $ = require 'jquery'
    Backbone = require 'backbone'
    ContactsView = require '../views/contactsView'
    app = Backbone.View.extend
        initialize: () ->
            this.contactsView = new ContactsView

    new app

