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
        render: () ->
            this.computeHeight()
            this.$el.html this.template this.collection.toJSON()
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
            this.render()







