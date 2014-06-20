Q = require 'q'
Imap = require 'imap'
mailServer = require '../conf/mailServer.json'
imapStore = {}

exports.init = (user, password, type) ->
    defer = Q.defer()
    if not imapStore[user]
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
