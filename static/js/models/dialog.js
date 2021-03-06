// Generated by CoffeeScript 1.7.1
(function() {
  define(function(require, exports, module) {
    var Backbone;
    Backbone = require('backbone');
    exports.model = Backbone.Model.extend({
      "default": {
        type: 'from',
        subject: '',
        text: '',
        contentType: 'text'
      }
    });
    exports.collection = Backbone.Collection.extend({
      model: exports.model,
      pull: function(address) {
        return this.fetch({
          url: '/dialog/' + address,
          reset: true
        });
      }
    });
    return exports;
  });

}).call(this);
