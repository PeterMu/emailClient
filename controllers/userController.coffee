ImapStore = require '../services/imapStore'
exports.login = (req, res) ->
    user = req.body.user
    password = req.body.password
    req.session.emailType = 'Gmail'
    ImapStore.init user, password, req.session.emailType
        .then ->
            req.session.user = user
            req.session.password = password
            res.json success:true
         , ->
            res.json success:false

exports.render = (req, res) ->
    if not req.session.user
        res.render 'login',title: 'Login'
    else
        res.redirect '/dashboard'

exports.signout = (req, res) ->
    ImapStore.removeImap req.session.user
    req.session.user = null
    req.session.password = null
    req.emailType = null
    res.json success:true


exports.getSession = (req,res) ->
    res.json user:req.session.user,password: req.session.password

    




