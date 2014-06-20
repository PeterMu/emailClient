define (require, exports, module) ->
    $ = require 'jquery'
    Mustache = require 'mustache'
    Backbone = require 'backbone'
    Contact = require '../models/contact'
    module.exports = Backbone.View.extend
        el: $('#email-contacts-list')
        tagName: 'ul'
        initialize: ()->
            that = this
            this.collection = new Contact.models
            this.collection.fetch reset:true
            this.collection.on 'reset', this.render, this
            this.$el.parent().find('.contacts-search input').keyup ->
                that.search.call that
        template: (data)->
            return Mustache.render($('#contact-item-tpl').text(), data)
        render: (data) ->
            this.computeHeight()
            if not data then data = this.collection
            this.$el.html this.template data.toJSON()
            return this
        computeHeight: () ->
            height = $(window).outerHeight() - this.$el.parent().find('.contacts-search').outerHeight()
            this.$el.height height
            that = this
            $(window).resize ()->
                height = $(window).outerHeight() - that.$el.parent().find('.contacts-search').outerHeight()
                that.$el.height height
        search: ()->
            e = window.event||arguments[0]
            value = $(e.target||e.srcElement).val()
            if value is ''
                this.render()
            else
                results = this.collection.select (model) ->
                    if model.get('name').indexOf(value) >-1
                        return true
                    else
                        return false
            console.log results
            this.render results
