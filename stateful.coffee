
path = require 'path'
fs = require 'fs'
util = require 'util'
# crypto = require 'crypto'
uid = require 'uid2'

debug = require('debug')('hand:stateful')

ho = require 'handover'
cookies = require 'cookies' 


FileStore = (option)->
  Store = 
    list: (callback)->

    get: (sid, callback)-> 
      debug  sid, option
      fp = path.join(option.dir, option.prefix + sid)
      fs.readFile fp, callback
    set: (sid, data)->
      fp = path.join(option.dir, option.prefix + sid)
      # console.log 'fp = ' ,fp
      fs.writeFile fp, JSON.stringify(data), (err)=>
        if err
          util.log('error when session save  - ', err, ' filepath : ', fp, ' / data : ', data)

    del: (sid)->
  return Store


session = (store)->
  return ho.make [
    (req,res,next)->
      # take session id from cookie

      debug 'in session ' , typeof  req, typeof res, typeof  next

      return next() if req.session 

      sid = req.cookies.get 'uwsi',
        singed: true
    
      if not sid  # create sid if not exists
        debug 'make sid'
        # rnd = crypto.pseudoRandomBytes(32)

        # sid = rnd.toString()
        sid = uid(24)

        debug 'set on cookie'
        req.cookies.set 'uwsi', sid,
          singed: true 
        req.tmp.sessionData = {}
        debug 'cookie set'
      req.tmp.sid = sid
      return next()
    (req,res,next)->  
      # load SessionData
      debug 'Load Session Data'
      return next() if req.tmp.sessionData 
      # debug 'store = ', store
      sid = req.tmp.sid
      store.get sid, (err, sessionJson)->
        debug 'get Session ',  err, sid, sessionJson
        if err
          debug 'next ',  typeof  next
          req.tmp.sessionData = {}
          store.set sid, {}
          return next()  
        req.tmp.sessionData = JSON.parse(sessionJson)
        next()
    (req,res,next)->  
      debug 'publish session interface'

      sessionData = req.tmp.sessionData 
      sid = req.tmp.sid
      req.session =
        set: (key, value)->
          sessionData[key] = value
          store.set sid, sessionData
        get: (key)->
          sessionData[key]
        unset: (key)->
          delete sessionData[key]          
        destroy :()->
          sessionData = {}
          store.del sid
      next()
    ]

    # req.session = 
    #   set: (key, value)->
    #     req.session[key] = value
    #     store.set()
    #     # data[key] = value
    #     # @Store.saveSession(@sid, @data)
    #   get: (key)->
    #     return @data[key] 
    #   has: (key)->
    #     return @data[key] isnt undefined
    #   clear: ()->
    #     @data = {}
    #     @Store.saveSession(@sid,  this)
  


stateful = (options = {} )-> 

  store = options.store || FileStore
    dir : (process.env.TMPDIR || process.env.TEMP)
    prefix : 'ho-sssion-'



  return ho.make [ 
    cookies.connect ['asdf', 'w42q3'] 
    session(store)
  ]



module.exports = exports = stateful 
stateful.FileStore = FileStore

