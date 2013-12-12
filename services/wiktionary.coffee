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

exports.lookup = (word, callback) ->
	if not word?
		console.log 'no word given'
		return 
	id = "" + uid(24)
	requestMap[id] = callback: callback
	connection.publish wktQueue, word, 
		replyTo: responseQueue.name
		correlationId: id
		mandatory: true
 	console.log "[x] message published, requestMap binding created, id:#{id}"

handleRpcResponse = (message, headers, deliveryInfo) ->
	console.log headers
	console.log deliveryInfo
	if deliveryInfo.correlationId? and requestMap[deliveryInfo.correlationId]?
		id = deliveryInfo.correlationId
		requestMap[id].callback(message)
		delete requestMap[id]
	else
		console.log '[x] stray rpc message received'
