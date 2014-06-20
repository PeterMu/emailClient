// Generated by CoffeeScript 1.7.1
(function() {
  define(function(require, exports, module) {
    var $, Backbone, Contact, Mustache;
    $ = require('jquery');
    Mustache = require('mustache');
    Backbone = require('backbone');
    Contact = require('../models/contact');
    return module.exports = Backbone.View.extend({
      el: $('#email-contacts-list'),
      tagName: 'ul',
      initialize: function() {
        var that;
        that = this;
        this.collection = new Contact.models;
        this.collection.fetch({
          reset: true
        });
        this.collection.on('reset', this.render, this);
        return this.$el.parent().find('.contacts-search input').keyup(function() {
          return that.search.call(that);
        });
      },
      template: function(data) {
        return Mustache.render($('#contact-item-tpl').text(), data);
      },
      render: function(data) {
        this.computeHeight();
        if (!data) {
          data = this.collection;
        }
        this.$el.html(this.template(data.toJSON()));
        return this;
      },
      computeHeight: function() {
        var height, that;
        height = $(window).outerHeight() - this.$el.parent().find('.contacts-search').outerHeight();
        this.$el.height(height);
        that = this;
        return $(window).resize(function() {
          height = $(window).outerHeight() - that.$el.parent().find('.contacts-search').outerHeight();
          return that.$el.height(height);
        });
      },
      search: function() {
        var e, results, value;
        e = window.event || arguments[0];
        value = $(e.target || e.srcElement).val();
        if (value === '') {
          this.render();
        } else {
          results = this.collection.select(function(model) {
            if (model.get('name').indexOf(value) > -1) {
              return true;
            } else {
              return false;
            }
          });
        }
        console.log(results);
        return this.render(results);
      }
    });
  });

}).call(this);
