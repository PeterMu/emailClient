UserController = require './controllers/userController'
EmailController = require './controllers/emailController'

module.exports = (app) ->
    app.get '/dashboard', EmailController.render
    app.get '/', UserController.render
    app.get '/login', UserController.render
    app.post '/login', UserController.login
    app.post '/signout', UserController.signout
    app.get '/contacts', EmailController.getContacts
