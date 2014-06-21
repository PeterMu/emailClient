EmailService = require '../services/emailService'
ImapStore = require '../services/imapStore'

exports.render = (req, res) ->
    email = req.session.user
    email = email.substring 0, email.lastIndexOf '@'
    if email.length >10 
        email = email.substring 0, 8
        email = email + '...'
    res.render 'index', title: 'Index',emailType:req.session.emailType,email:email

exports.getContacts = (req, res) ->
    EmailService.getContacts req.session.user, req.session.password, req.session.emailType
       .then (contacts) ->
           res.json contacts
