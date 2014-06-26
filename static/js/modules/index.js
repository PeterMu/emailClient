// Generated by CoffeeScript 1.7.1
(function() {
  define(function(require, exports, module) {
    var $, Backbone, ContactsView, DialogView, app, _;
    $ = require('jquery');
    Backbone = require('backbone');
    ContactsView = require('../views/contactsView');
    DialogView = require('../views/dialogView');
    _ = require('underscore');
    app = Backbone.View.extend({
      initialize: function() {
        var that;
        that = this;
        this.contactsView = new ContactsView;
        this.dialogView = new DialogView;
        $('.signout a').click(this.signout);
        this.contactsView.collection.on('loadDialog', function(address) {
          return that.dialogView.trigger('loadDialog', address);
        });
        return $(function() {
          that.computeSize();
          return $('.quick-reply input').focus(function(e) {
            return $(this).parent().css('bottom', '-20px');
          });
        });
      },
      signout: function(e) {
        e.preventDefault();
        return $.post('/signout', function(data) {
          if (data.success) {
            return document.location.href = '/login';
          }
        });
      },
      computeSize: function() {
        var height, width;
        height = $(window).outerHeight() - 120;
        width = $('#dialog-list').outerWidth();
        $('#dialog-list').height(height);
        $('.email-dialog').find('.quick-reply').outerWidth(width);
        console.log(width);
        return $(window).resize(function() {
          height = $(window).outerHeight() - 120;
          width = $('#dialog-list').outerWidth();
          $('#dialog-list').height(height);
          return $('.email-dialog').find('.quick-reply').outerWidth(width);
        });
      }
    });
    return new app;
  });

}).call(this);
