ImapStore = require '../services/imapStore'
exports.login = (req, res) ->
    user = req.body.user
    password = req.body.password
    req.session.user = user
    req.session.password = password
    req.session.emailType = 'Gmail'
    ImapStore.init user, password, req.session.emailType
        .then () ->
            res.json success:true

exports.render = (req, res) ->
    res.render 'login',title: 'Login'

exports.getSession = (req,res) ->
    res.json user:req.session.user,password: req.session.password

    




