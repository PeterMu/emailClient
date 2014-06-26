EmailService = require '../services/emailService'
ImapStore = require '../services/imapStore'

exports.render = (req, res) ->
    email = req.session.user
    email = email.substring 0, email.lastIndexOf '@'
    if email.length >10
        email = email.substring 0,10
        email = email + '...'
    res.render 'index', title: 'Index',emailType:req.session.emailType,email:email

exports.getContacts = (req, res) ->
    EmailService.getContacts req.session.user, req.session.password, req.session.emailType
       .then (contacts) ->
           res.json contacts

exports.getUnseenEmail = (req, res) ->
    EmailService.getUnseenEmail req.session.user, 5
        .then (mails)->
            res.json mails
        .then (err) ->
            res.json ''

exports.getDialog = (req, res)->
    EmailService.getDialog req.session.user, req.params.address, 5
        .then (mails)->
            res.json mails
        .then (err) ->
            res.json ''
