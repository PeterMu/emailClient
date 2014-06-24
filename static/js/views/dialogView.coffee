define (require,exports, module)->
    $ = require 'jquery'
    Mustache = require 'mustache'
    Backbone = require 'backbone'
    Dialog = require '../models/dialog'

    dialogItem = Backbone.View.extend
        events:
            'click .show-more': 'showMore'
        template: ()->
            return Mustache.render $('#dialog-from-tpl').text(), this.model.toJSON()
        render: ()->
            this.$el.html this.template()
            return this
        showMore: ()->
            fa = this.$('.show-more').find '.fa'
            if fa.hasClass 'fa-angle-down'
                fa.removeClass('fa-angle-down').addClass('fa-angle-up')
                this.$('.dialog-article').css 'max-height':'100%'
            else
                fa.removeClass('fa-angle-up').addClass('fa-angle-down')
                this.$('.dialog-article').css 'max-height':'200px'


    module.exports = Backbone.View.extend
        el: $('#dialog-list')
        events:
            'click h4':this.test
        initialize: ()->
            this.collection = new Dialog.collection
            this.collection.on 'reset',this.renderAll,this
        renderOne: (model)->
            item = new dialogItem model:model
            this.$el.append item.render().el
        renderAll: ()->
            this.collection.each this.renderOne, this
        pullData: (type,address)->
            this.collection.pull type, address



