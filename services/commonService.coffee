#基本的业务操作，比如查询、添加记录之类的
Q = require 'q'
db = require '../db/common'

exports.findAll = (user) ->
    deferred = Q.defer()
    db.execute user, 'select * from user'
    .then (result) ->
        deferred.resolve result
    return deferred.promise

exports.findByPage = (user,model,conditions,start=0,limit=100) ->
    deferred = Q.defer()
    sql = 'select * from ' + model + ' where 1=1 ' + conditionsToSQL conditions
    sql = sql + ' limit ' + start + ',' + limit
    db.execute 'mis', sql
    .then (result) ->
        deferred.resolve result
    return deferred.promise

#插入
exports.insert  = (user,model,attrs) ->
    deferred = Q.defer()
    sql = 'insert into ' + model + ' set ?'
    db.execute sql, attrs
    .then (result) ->
       deferred.resolve result.insertId
    ,(err) ->
        deferred.reject err
    return deferred.promise

#更新
exports.update = (user,model,updateAttrs,conditions) ->
    names = []
    whereNames = []
    for name,value of attrs
        do (name,value) ->
            names.push name + '=:' + name
    for name,value of wheres
        do (name,value) ->
            whereNames.push name + '=:' + name
    sql = 'update ' + model + 'set ' + names.join ',' + ' where ' + conditionsToSQL conditions










#private functions
conditionsToSQL = (conditions) ->
    conSql = for cond in conditions
        if cond.oper isnt 'like'
            if cond.logic
                "#{cond.logic} #{cond.name} #{cond.oper} '#{cond.value}'"
            else
                "and #{cond.name} #{cond.oper} '#{cond.value}'"
        else
            if cond.logic
                "#{cond.logic} #{cond.name} #{cond.oper} '%#{cond.value}%'"
            else
                "and #{cond.name} #{cond.oper} '%#{cond.value}%'"
    return conSql.join ' '
