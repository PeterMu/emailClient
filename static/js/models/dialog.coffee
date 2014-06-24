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
        pull: (type,address)->
            if type is 'from'
                this.fetch url: '/unseen/' + address, reset: true
            else
                this.fetch url: '/sent/' + address, reset: true

    return exports






