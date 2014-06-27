define (require, exports, module) ->
    $ = require 'jquery'
    Mustache = require 'mustache'
    Backbone = require 'backbone'
    Contact = require '../models/contact'

    contactItem = Backbone.View.extend
        events:
            'click': 'loadDialog'
        template: ()->
            return Mustache.render $('#contact-item-tpl').text(), this.model.toJSON()
        render: ()->
            this.$el.html this.template()
            return this
        loadDialog: ()->
            this.$el.parent().find('li').removeClass 'highlight'
            #this.$('li').addClass 'highlight'
            this.model.collection.trigger 'loadDialog',this.model.get 'email'
            $('.dialog-header').text this.model.get 'name'
            $('.dialog-header').data 'email', this.model.get 'email'

    module.exports = Backbone.View.extend
        el: $('#email-contacts-list')
        tagName: 'ul'
        initialize: ()->
            this.computeHeight()
            that = this
            this.collection = new Contact.collection
            this.collection.fetch reset:true
            this.collection.on 'reset', this.renderAll, this
            this.collection.on 'add', this.preRenderOne, this
            this.$el.parent().find('.contacts-search input').keyup ->
                that.search.call that
            setInterval ()->
                that.getUnseen that
            ,1000*20
        renderOne: (data) ->
            if data.get('haveUnseen') is true
                this.preRenderOne data
            else
                this.$el.append new contactItem(model: data).render().el
            return this
        preRenderOne: (data)->
            this.$el.prepend new contactItem(model: data).render().el
            return this
        renderAll: ()->
            this.$el.children().remove()
            this.collection.each this.renderOne, this
        computeHeight: () ->
            height = $(window).outerHeight() - this.$el.parent().find('.contacts-search').outerHeight()
            this.$el.height height
            that = this
            $(window).resize ()->
                height = $(window).outerHeight() - that.$el.parent().find('.contacts-search').outerHeight()
                that.$el.height height
        search: ()->
            e = window.event||arguments[0]
            value = $(e.target||e.srcElement).val().toUpperCase()
            if value is ''
                results = this.collection.where show:false
                results.forEach (ele) ->
                    ele.set show: true
            else
                this.collection.forEach (ele) ->
                    if ele.get('name').toUpperCase().indexOf(value) is -1
                        ele.set show:false,silent: true
                    else
                        ele.set show:true,silent: true
            this.renderAll()
        getUnseen: (that)->
            $.get '/unseen', (mails)->
                from = ''
                mails.forEach (mail)->
                    from += mail.from[0].address
                that.collection.forEach (value)->
                    if from.indexOf(value.get('email')) > 0
                        value.set haveUnseen:true
                that.renderAll()







