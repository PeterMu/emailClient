Q = require 'q'
pool = require './pool'

#执行SQL语句，第一参数必须是用户代码
exports.query = (sql, params) ->
    deferred = Q.defer()
    pool.getConn()
    .then (conn) ->
        query = null
        if params
            query = conn.query sql, params, (err, res) ->
                if not err
                    deferred.resolve res
                else
                    console.log '执行SQL出现错误：'
                    console.log err
                    deferred.reject err
                conn.release()
        else
            query = conn.query sql, (err,res) ->
                if not err
                    deferred.resolve res
                else
                    console.log '执行SQL出现错误：'
                    console.log err
                    deferred.reject err
                conn.release()
        console.log query.sql
    return deferred.promise
