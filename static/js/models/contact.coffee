define (require,exports,module) ->
    Backbone = require 'backbone'
    model = Backbone.Model.extend
        defaults:
            name: ''
            email: ''
            show: true
            haveUnseen: false
        initialize : ()->
    models = Backbone.Collection.extend
        model: model
        url: '/contacts'

    exports.model = model
    exports.collection = models
    return exports
