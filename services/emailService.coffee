Q = require 'q'
Imap = require 'imap'
ImapStore = require './imapStore'
ImapUtil = require './imapUtil'
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





