Q = require 'q'
Imap = require 'imap'
ImapStore = require './imapStore'
ImapUtil = require './imapUtil'
MailParser = require('mailparser').MailParser

exports.getContacts = (user) ->
    defer = Q.defer()
    contactsArray = []
    imap = ImapStore.getImap user
    openInbox = (cb) ->
        imap.openBox 'INBOX',true,cb
    openInbox (err,box) ->
        if err
            throw err
        start = 0
        if box.messages.total > 200
            start = box.messages.total-200
        else
            start = 1
        f = imap.seq.fetch start+':'+box.messages.total,bodies:'HEADER.FIELDS (FROM)',struct:true
        f.on 'message',(msg, seqNo) ->
            msg.on 'body',(stream, info) ->
                buffer = ''
                stream.on 'data',(chunk) ->
                    buffer += chunk.toString('utf8')
                stream.on 'end',() ->
                    contactsArray.push Imap.parseHeader buffer
        f.once 'error',(err) ->
            defer.reject err
        f.once 'end', () ->
            defer.resolve ImapUtil.parseHeader contactsArray
    return defer.promise

exports.getUnseenEmail = (user, limit) ->
    defer = Q.defer()
    imap = ImapStore.getImap user
    openInbox = (cb) ->
        imap.openBox 'INBOX',true,cb
    openInbox (err,box) ->
        if err
            defer.resolve []
        imap.seq.search ['UNSEEN'], (err, results) ->
            if err
                defer.resolve []
            array = []
            results = results.slice 0-limit
            if results.length > 0
                f = imap.seq.fetch results, bodies:'',markSeen: true
                f.on 'message', (msg, seqNo) ->
                    mailParser = new MailParser defaultCharset:'utf8'
                    mailParser.on 'end', (mail) ->
                        array.push mail
                    msg.on 'body', (stream, info)->
                        stream.pipe mailParser
                f.on 'error', (err) ->
                    console.log err
                    defer.resolve []
                f.once 'end', ()->
                    defer.resolve array
            else
                defer.resolve []
    return defer.promise

exports.getInboxEmail = (user, from, limit) ->
    defer = Q.defer()
    imap = ImapStore.getImap user
    openInbox = (cb) ->
        imap.openBox 'INBOX',true,cb
    openInbox (err,box) ->
        if err
            defer.resolve []
        imap.seq.search ['ALL',['FROM', from]], (err, results) ->
            if err
                defer.resolve []
            array = []
            results = results.slice 0-limit
            if results.length > 0
                f = imap.seq.fetch results, bodies:''
                f.on 'message', (msg, seqNo) ->
                    mailParser = new MailParser defaultCharset:'utf8'
                    mailParser.on 'end', (mail) ->
                        array.push mail
                    msg.on 'body', (stream, info)->
                        stream.pipe mailParser
                f.on 'error', (err) ->
                    console.log err
                    defer.resolve []
                f.once 'end', ()->
                    defer.resolve array
            else
                defer.resolve []
    return defer.promise
                
exports.getSentEmail = (user, to, limit) ->
    defer = Q.defer()
    imap = ImapStore.getImap user
    openInbox = (cb) ->
        imap.openBox '[Gmail]/已发邮件',true,cb
    openInbox (err,box) ->
        if err
            defer.resolve []
        imap.seq.search ['ALL',['TO', to]], (err, results) ->
            if err
                defer.resolve []
            array = []
            results = results.slice 0-limit
            if results.length > 0
                f = imap.seq.fetch results, bodies:''
                f.on 'message', (msg, seqNo) ->
                    mailParser = new MailParser defaultCharset:'utf8'
                    mailParser.on 'end', (mail) ->
                        array.push mail
                        if array.length is results.length
                            defer.resolve array
                    msg.on 'body', (stream, info)->
                        stream.pipe mailParser
                f.on 'error', (err) ->
                    console.log err
                    defer.resolve []
            else
                defer.resolve array
    return defer.promise

exports.getDialog = (user, address, limit) ->
    inboxArray = null
    sentArray = null
    topDefer = Q.defer()
    exports.getInboxEmail user, address, limit
    .then (mails)->
        defer = Q.defer()
        inboxArray = mails
        defer.resolve()
        return defer.promise
    .then ()->
        defer = Q.defer()
        exports.getSentEmail user, address, limit
        .then (mails)->
            sentArray = mails
            defer.resolve()
        return defer.promise
    .then ()->
        topDefer.resolve concatInboxAndSent inboxArray, sentArray
    return topDefer.promise
#concat unseen box and sent box, and sory by data
concatInboxAndSent = (inbox, sent)->
    inbox.forEach (mail)->
        mail.type = 'from'
        if !mail.text
           mail.text = mail.html
    sent.forEach (mail)->
        mail.type = 'to'
        if !mail.text
           mail.text = mail.html
    array = inbox.concat sent
    return array.sort (i,j)->
        return i.date.getTime() > j.date.getTime()














