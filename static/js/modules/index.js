// Generated by CoffeeScript 1.7.1
(function() {
  define(function(require, exports, module) {
    var $, Backbone, ContactsView, app;
    $ = require('jquery');
    Backbone = require('backbone');
    ContactsView = require('../views/contactsView');
    app = Backbone.View.extend({
      initialize: function() {
        return this.contactsView = new ContactsView;
      }
    });
    return new app;
  });

}).call(this);
