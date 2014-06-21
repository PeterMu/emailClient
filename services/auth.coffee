exports.loginAuth = (req, res, next) ->
    if req.session.user or req.path is '/login'
        next()
    else
        res.redirect '/login'
