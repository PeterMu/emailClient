define (require,exports, module)->
    $ = require 'jquery'
    Mustache = require 'mustache'
    Backbone = require 'backbone'
    Dialog = require '../models/dialog'

    dialogItem = Backbone.View.extend
        initialize: ->
            this.model.on 'distroy',this.removeDom,this
        events:
            'click .show-more': 'showMore'
            'click .fa-reply': 'reply'
        template: ()->
            if this.model.get('type') is 'from'
                return Mustache.render $('#dialog-from-tpl').text(), this.model.toJSON()
            else
                return Mustache.render $('#dialog-to-tpl').text(), this.model.toJSON()
        render: ()->
            this.$el.html this.template()
            if this.model.get('type') is 'to'
                width = $(window).outerWidth()-1320
                if width < 0
                    this.$('.item-to').css 'left', '30px'
                else
                    this.$('.item-to').css 'left', width
            return this
        showMore: ()->
            fa = this.$('.show-more').find '.fa'
            if fa.hasClass 'fa-angle-down'
                fa.removeClass('fa-angle-down').addClass('fa-angle-up')
                this.$('.dialog-article').css 'max-height':'100%'
            else
                fa.removeClass('fa-angle-up').addClass('fa-angle-down')
                this.$('.dialog-article').css 'max-height':'200px'
        reply: ()->
            $reply = $('.quick-reply')
            $reply.css('bottom','-20px')
            $reply.find('input').val 'Re: ' + this.model.get('subject')
            $reply.find('textarea').focus()
        removeDom: ()->
            this.$el.remove()



    module.exports = Backbone.View.extend
        el: $('#dialog-list')
        events:
            'click h4':this.test
        initialize: ()->
            that = this
            this.collection = new Dialog.collection
            this.collection.on 'reset',this.renderAll,this
            this.on 'loadDialog', (address)->
                that.pullData address
            this.collection.on 'add',this.renderOne, this
            this.collection.on 'remove',this.removeDialog, this
        renderOne: (model)->
            item = new dialogItem model:model
            this.$el.append item.render().el
        renderAll: ()->
            this.$el.children().remove()
            this.collection.each this.renderOne, this
        pullData: (address)->
            this.collection.pull address
        removeDialog: (model)->
            model.distroy()



