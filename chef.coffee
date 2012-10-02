request = require 'request'
url     = require 'url'
crypto  = require 'crypto'
fs      = require 'fs'
exec    = require('child_process').exec


user = null
key = null
endpoint = null

sha = (str) ->
	sum = crypto.createHash 'sha1'
	sum.update str
	sum.digest 'base64'

exports.auth = (myUser, pem, myUrl) ->
	console.log(myUser, pem, myUrl)
	user = myUser
	key = pem
	endpoint = myUrl

exports.request = (target, body, method, cb) ->
	[body, cb] = [undefined, body] unless cb?
		
	uri = endpoint + target
	timestamp = new Date().toISOString().replace(/\....Z/,"Z") #Shave off the milliseconds
	hashedPath = sha url.parse(uri).path
	hash = sha (if body then JSON.stringify body else '')

	canonicalRequest = "Method:#{method}\\nHashed Path:#{hashedPath}\\nX-Ops-Content-Hash:#{hash}\\nX-Ops-Timestamp:#{timestamp}\\nX-Ops-UserId:#{user}"

	exec "printf '#{canonicalRequest}' | openssl rsautl -sign -inkey #{key} | openssl enc -base64", (e, stdout) ->

		signature = stdout.replace /\s+/g, ''

		headers = {
			"Accept":             "application/json"
			"X-Ops-Timestamp":    timestamp
			"X-Ops-UserId":       user
			"X-Ops-Content-Hash": hash
			"X-Chef-Version":     "0.10.4"
			"X-Ops-Sign":         "version=1.0"
    		}

		for h, i in signature.match /.{1,60}/g
			headers["X-Ops-Authorization-#{i+1}"] = h
		req = {method, body, headers}
		req = {method:method, json:body, headers:headers} if method == "POST" || method == "PUT"
		request uri, req, cb
