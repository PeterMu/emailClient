Q = require 'q'
Imap = require 'imap'
mailServer = require './conf/mailServer.json'
imapStore = {}
fs = require 'fs'
MailParser = require('mailparser').MailParser

exports.init = (user, password, type) ->
    defer = Q.defer()
    if imapStore[user] then imapStore[user].end()
    server = mailServer[type]
    imap = new Imap
        user:user,
        password:password,
        host:server.imap.host,
        port:server.imap.port,
        tls:true
    imap.once 'ready', ()->
        imapStore[user] = imap
        defer.resolve imap
    imap.once 'error',(err) ->
        console.log err
        defer.reject err
    imap.once 'end',() ->
        imapStore[user] = null
    imap.connect()
    return defer.promise

exports.getImap = (user) ->
    if imapStore[user] isnt null
        return imapStore[user]
    else
        return 1001 #not login

exports.removeImap = (user) ->
    imapStore[user] = null

exports.init 'mutiezhai@gmail.com','19890728','Gmail'
    .then (imap) ->
        openInbox = (cb) ->
            imap.openBox 'INBOX',true,cb
        openInbox (err,box) ->
            if err
                throw err
            imap.seq.search ['UNSEEN',['FROM','noreply@dajie.com']], (err, results) ->
                if err
                    throw err
                results = results[-5..-1]
                console.log results
                f = imap.seq.fetch results, bodies:'',markSeen:true
                f.on 'message', (msg,seqNo) ->
                    mailParser = new MailParser defaultCharset: 'utf8'
                    mailParser.on 'end', (mail) ->
                        console.log mail.html
                    msg.on 'body', (stream, info) ->
                        stream.pipe mailParser
                f.once 'end', () ->
                    imap.end()

            #total = box.messages.total
            #f = imap.seq.fetch (total-1) + ':' + total, bodies:''
            #f.on 'message', (msg, seqNo) ->
            #    mailParser = new MailParser defaultCharset:'utf8'
            #    mailParser.on 'end', (mail) ->
            #        console.log mail.from
            #    msg.on 'body', (stream, info) ->
            #        stream.on 'data', (chunk)->
            #            mailParser.write chunk
            #    msg.once 'end', ()->
            #        mailParser.end()
            #f.on 'error',(err)->
            #    console.log err
            #f.on 'end',()->
            #    console.log 'end'


















