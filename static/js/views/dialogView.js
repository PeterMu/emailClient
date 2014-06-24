// Generated by CoffeeScript 1.7.1
(function() {
  define(function(require, exports, module) {
    var $, Backbone, Dialog, Mustache, dialogItem;
    $ = require('jquery');
    Mustache = require('mustache');
    Backbone = require('backbone');
    Dialog = require('../models/dialog');
    dialogItem = Backbone.View.extend({
      events: {
        'click .show-more': 'showMore'
      },
      template: function() {
        return Mustache.render($('#dialog-from-tpl').text(), this.model.toJSON());
      },
      render: function() {
        this.$el.html(this.template());
        return this;
      },
      showMore: function() {
        var fa;
        fa = this.$('.show-more').find('.fa');
        if (fa.hasClass('fa-angle-down')) {
          fa.removeClass('fa-angle-down').addClass('fa-angle-up');
          return this.$('.dialog-article').css({
            'max-height': '100%'
          });
        } else {
          fa.removeClass('fa-angle-up').addClass('fa-angle-down');
          return this.$('.dialog-article').css({
            'max-height': '200px'
          });
        }
      }
    });
    return module.exports = Backbone.View.extend({
      el: $('#dialog-list'),
      events: {
        'click h4': this.test
      },
      initialize: function() {
        this.collection = new Dialog.collection;
        return this.collection.on('reset', this.renderAll, this);
      },
      renderOne: function(model) {
        var item;
        item = new dialogItem({
          model: model
        });
        return this.$el.append(item.render().el);
      },
      renderAll: function() {
        return this.collection.each(this.renderOne, this);
      },
      pullData: function(type, address) {
        return this.collection.pull(type, address);
      }
    });
  });

}).call(this);
