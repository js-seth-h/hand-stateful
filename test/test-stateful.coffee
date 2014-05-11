request = require 'supertest'


describe 'hand-stateful', ()->

  ho = require 'handover'
  stateful = require '../stateful'
  http = require 'http'

  getSession = (req,res, next)->
      # console.log req.url
      return next() unless  req.url is '/get'
      data = req.session.get('s-key')
      # console.log 'data', data
      res.end data
  setSession = (req,res, next)->
      # console.log req.url
      return next() unless  req.url is '/set'
      req.session.set('s-key', 'test-result')
      # console.log 'set data', 
      res.end 'set'

  server = http.createServer ho.make [
    stateful
      store : stateful.FileStore
        dir : './tmp'  #(process.env.TMPDIR || process.env.TEMP)
        prefix : 'ho-sssion-'

    getSession
    setSession
  ]

  agent = request.agent(server);
    
  it 'should set ', (done)-> 
    # request(server)
    agent.get('/set')
      .expect(200, 'set') 
      .end done

  it 'should get ', (done)-> 
    agent.get('/get')
      .expect(200, 'test-result')
      .end done

  # it 'send json', (done)-> 
  #   check = 
  #     status : 'ok'
  #   request(server)
  #     .get('/')
  #     .expect(200)
  #     .end (err, res)->
  #       return done(err) if (err) 
  #       return done(err) if not  JSON.stringify(res.body) is JSON.stringify check
  #       done() 


  # it 'redirect', (done)-> 
  #   request(server)
  #     .get('/redirect')
  #     .expect(302)
  #     .end done


  # it "send jsonp ", (done) ->
  #   check = 
  #     status: 'ok'
  #   request(server)
  #     .get("/jsonp")
  #     .expect(200)
  #     .expect("Content-Type", "application/javascript")
  #     .expect '\r\ncallback({"status":"ok"})', done




  # describe 'with-connect', ()->


  #   connect = require('connect') 

  #   app = connect()
  #   app.use response()
  #   app.use (req,res, next)->
  #     res.send( "test")


  #   it 'send text', (done)-> 
  #     check = "hello"
  #     request(server)
  #       .get('/')
  #       .expect(200, check)
  #       .end(done)
