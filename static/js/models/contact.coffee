define (require,exports,module) ->
    Backbone = require 'backbone'
    model = Backbone.Model.extend
        defaults:
            name: ''
            email: ''
        initialize : ()->
    models = Backbone.Collection.extend
        model: model
        url: '/contacts'

    exports.model = model
    exports.models = models
    return exports
