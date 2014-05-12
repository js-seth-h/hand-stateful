# hand-stateful

> http stateful ( cookie & session support), compatible with handover, connect/express


## Why made this?

[express-session][es], recommanded by connect/express, overwrite cookie. so, I can use cookie & session concurrently.

This module is support cookie (by [cookies][co]), and session.

Install this, then you can enjoy stateful http!

[co]: https://www.npmjs.org/package/cookies
[es]: https://www.npmjs.org/package/express-session
## Features

* compatible with connect/express
* cookie - set, get  ( visit [cookies][co])
* session - set, get
* default session store = File
* session store can replace with any object(or class instance) has 4 function: list, get, set, del
* currently, default file store, support get/set only, list/del is future works.

## Examples
 

```coffee 
  ho = require 'handover'
  stateful = require 'hand-stateful'
  http = require 'http'
 
  getSession = (req,res, next)-> 
      return next() unless  req.url is '/get'
      data = req.session.get('s-key') 
      res.end data
  setSession = (req,res, next)-> 
      return next() unless  req.url is '/set'
      req.session.set('s-key', 'test-result') 
      res.end 'set'

  server = http.createServer ho.make [
    stateful()
    getSession
    setSession
  ]

```
with default option.


```coffee 
  ho = require 'handover'
  stateful = require 'hand-stateful'
  http = require 'http'
 
  server = http.createServer ho.make [
    stateful
      store : stateful.FileStore
        dir : (process.env.TMPDIR || process.env.TEMP)
        prefix : 'ho-sssion-' 
    getSession
    setSession
  ]

```
with sepecific store.

```coffee  
    connect = require('connect') 
    app = connect()
    app.use stateful
      store : stateful.FileStore
        dir : (process.env.TMPDIR || process.env.TEMP)
        prefix : 'ho-sssion-' 
    app.use getSession
    app.use setSession 
```
with connect, specific store
 
 
## License

(The MIT License)

Copyright (c) 2014 junsik &lt;js@seth.h@google.com&gt;

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 