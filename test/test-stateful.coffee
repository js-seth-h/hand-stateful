request = require 'supertest'


describe 'httpware-stateful', ()->

  ficent = require 'ficent'
  stateful = require '../src' #  require 'httpware-stateful'
  http = require 'http'

  getSession = (req,res, next)-> 
      return next() unless  req.url is '/get'
      data = req.session.get('s-key') 
      res.end data
  setSession = (req,res, next)-> 
      return next() unless  req.url is '/set'
      req.session.set('s-key', 'test-result') 
      res.end 'set'

  server = http.createServer ficent [
    stateful()
      # store : stateful.FileStore
      #   dir : (process.env.TMPDIR || process.env.TEMP)
      #   prefix : 'ficent-sssion-'

    getSession
    setSession
  ]

  agent = request.agent(server);
    
  it 'sficentuld set ', (done)-> 
    # request(server)
    agent.get('/set')
      .expect(200, 'set') 
      .end done

  it 'sficentuld get ', (done)-> 
    agent.get('/get')
      .expect(200, 'test-result')
      .end done
 

  describe 'with connect', ()->


    getSession = (req,res, next)-> 
        return next() unless  req.url is '/get'
        data = req.session.get('s-key') 
        res.end data
    setSession = (req,res, next)-> 
        return next() unless  req.url is '/set'
        req.session.set('s-key', 'test-result') 
        res.end 'set'



    connect = require('connect') 
    app = connect()
    app.use stateful()
    app.use getSession
    app.use setSession 

    agent = request.agent(server);
      
    it 'sficentuld set ', (done)-> 
      # request(server)
      agent.get('/set')
        .expect(200, 'set') 
        .end done

    it 'sficentuld get ', (done)-> 
      agent.get('/get')
        .expect(200, 'test-result')
        .end done
   