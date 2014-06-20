EmailService = require '../services/emailService'
ImapStore = require '../services/imapStore'

exports.render = (req, res) ->
    res.render 'index', title: 'Index',emailType:req.session.emailType

exports.getContacts = (req, res) ->
    EmailService.getContacts req.session.user, req.session.password, req.session.emailType
       .then (contacts) ->
           res.json contacts
