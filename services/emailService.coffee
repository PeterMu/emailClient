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
        if box.messages.total > 100
            start = box.messages.total-100
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

exports.getUnseenEmail = (user, from, limit) ->
    defer = Q.defer()
    imap = ImapStore.getImap user
    openInbox = (cb) ->
        imap.openBox 'INBOX',true,cb
    openInbox (err,box) ->
        if err
            throw err
        imap.seq.search ['UNSEEN',['FROM', from]], (err, results) ->
            throw err if err
            array = []
            results = results.slice 0-limit
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
    return defer.promise
                
exports.getSentEmail = (user, to, limit) ->
    defer = Q.defer()
    imap = ImapStore.getImap user
    openInbox = (cb) ->
        imap.openBox 'Sent Mail',true,cb
    openInbox (err,box) ->
        if err
            throw err
        imap.seq.search ['ALL',['TO', to]], (err, results) ->
            throw err if err
            array = []
            results = results.slice 0-limit
            f = imap.seq.fetch results, bodies:'',markSeen: true
            f.on 'message', (msg, seqNo) ->
                mailParser = new MailParser defaultCharset:'utf8'
                mailParser.on 'end', (mail) ->
                    array.push mail
            f.on 'err', (err) ->
                console.log err
                defer.resolve []

            f.once 'end', ()->
                defer.resolve array
    return defer

exports.getDialog = (user, address, limit) ->
    unseenArray = null
    sentArray = null
    topDefer = Q.defer()
    exports.getUnseenEmail user, address, limit
    .then (mails)->
        defer = Q.defer()
        unseenArray = mails
        defer.resolve()
        console.log 'unseen='+unseenArray.length
        return defer.promise
    .then ()->
        defer = Q.defer()
        exports.getSentEmail user, address, limit
            .then (mails) ->
                sentArray = mails
                defer.resolve()
                console.log 'sent='+sentArray.length
        return defer.promise
    .then ()->
        topDefer.resolve concatUnseenAndSent unseenArray, sentArray
    return topDefer.promise
#concat unseen box and sent box, and sory by data
concatUnseenAndSent = (unseen, sent)->
    unseen.forEach (mail)->
        mail.type = 'from'
    sent.forEach (mail)->
        mail.type = 'to'
    array = unseen.concat sent
    return array.sort (i,j)->
        return i.date.getTime() > j.date.getTime()














