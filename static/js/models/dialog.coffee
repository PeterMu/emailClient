define (require, exports, module)->
    Backbone = require 'backbone'
    exports.model = Backbone.Model.extend
        default:
            type: 'from'
            subject: ''
            content: ''
            contentType: 'text'
    exports.collection = Backbone.Collection.extend
        model: exports.model
        pull: (address)->
            this.fetch url: '/dialog/' + address, reset: true

    return exports






