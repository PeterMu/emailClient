http = require 'http'
express = require 'express'
jade = require 'jade'
session = require 'cookie-session'
bodyParser = require 'body-parser'
auth = require './services/auth'
app = express()


#body parser
app.use bodyParser.urlencoded()
app.use bodyParser.json()
app.use bodyParser.json type: 'application/vnd.api+json'
#session
app.use session keys: ['peter', 'dnspod']

#view engine
app.set 'view engine','jade'
app.use express.static  __dirname + '/static'

#auth
app.use auth.loginAuth

#routes
routes = require './routes'
routes app

#catch uncaughtException
process.on 'uncaughtException', (err) ->
    console.log 'uncaughtException: '+err

http.createServer app
.listen 8080,()->console.log 'server start...'
