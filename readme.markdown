# fork of chef-node
* added support for PUTs (some modes require puts)
* added more generic support for various url formats chef needs
* added single endpoint support (simplifies URL concatenation for individual calls)

Usage:
`var chef = require('chef')`

`.auth(username, path_to_pemfile, baseUrl)`

`.request(apiTarget, body, method, callback)`

* apiTarget (ie node/NODENAME)
* body - JSON object to post or put (omit for get)
* method - 'PUT','POST','GET'
* callback - standard 'request' callback (err,resp,body)

note that unlike the parent repo the callback returns the raw callback so you can do with it what you which (ie its not parsed by default to make debugging simpler)