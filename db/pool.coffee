Q = require 'q'
mysql = require 'mysql'

pool = mysql.createPool
    host: 'localhost'
    user: 'email'
    password: 'email'
    database: 'email'
#    debug: true

exports.getConn = (user)->
    deferred = Q.defer()
    pool.getConnection (err,conn) ->
        if not err
            deferred.resolve conn
        else
            console.log 'get conn failed:'
            console.log err
            deferred.reject conn

    return deferred.promise

    




