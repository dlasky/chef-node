## Changelog
* added support for PUTs (some modes require puts)
* added more generic support for various url formats chef needs
* added single endpoint support (simplifies URL concatenation for individual calls)
* callback now reutrns raw body for situations where you may not want to parse it

## Usage:
`var chef = require('chef')`

`.auth(username, path_to_pemfile, baseUrl)`

`.request(apiTarget, body, method, callback)`

* apiTarget (ie node/NODENAME)
* body - JSON object to post or put (omit for get)
* method - 'PUT','POST','GET'
* callback - standard 'request' callback (err,resp,body)