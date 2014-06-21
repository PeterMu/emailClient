// Generated by CoffeeScript 1.7.1
(function() {
  define(function(require, exports, module) {
    var Backbone, model, models;
    Backbone = require('backbone');
    model = Backbone.Model.extend({
      defaults: {
        name: '',
        email: '',
        show: true
      },
      initialize: function() {}
    });
    models = Backbone.Collection.extend({
      model: model,
      url: '/contacts'
    });
    exports.model = model;
    exports.models = models;
    return exports;
  });

}).call(this);
