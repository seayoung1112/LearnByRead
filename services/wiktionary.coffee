amqp = require('amqp')
connection = amqp.createConnection()
responseQueue = {}
requestMap = {}
wktQueue = 'wkt_queue'
connection.on 'ready', ->
	console.log '[x] amqp connection established'
	connection.queue '', {exclusive: true}, (queue) ->
		console.log "[x] rpc queue created: #{queue.name}"
		queue.subscribe handleRpcResponse
		responseQueue = queue  

connection.on 'error', (e)->
	console.log "[x] connection error #{e}"

uid = require 'uid2'

TIMEOUT_LIMIT = 1000

exports.lookup = (word, callback) ->
	if not word?
		return callback "no word given", null
	id = "" + uid(24)
	requestMap[id] = callback: callback
	setTimeout handleTimeout, TIMEOUT_LIMIT, id
	connection.publish wktQueue, word, 
		replyTo: responseQueue.name
		correlationId: id
 	console.log "[x] message published, requestMap binding created, id:#{id}"

handleRpcResponse = (message, headers, deliveryInfo) ->
	console.log headers
	console.log deliveryInfo
	if deliveryInfo.correlationId? and requestMap[deliveryInfo.correlationId]?
		id = deliveryInfo.correlationId
		requestMap[id].callback null, message
		delete requestMap[id]
	else
		console.log '[x] stray rpc message received'

handleTimeout = (id) ->
	console.log "dictionary server timeout, dispose #{id}"
	requestMap[id].callback "dictionary server timeout", null
	delete requestMap[id]