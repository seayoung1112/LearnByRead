wkt = require "../services/wiktionary"
StringDecoder = require('string_decoder').StringDecoder
decoder = new StringDecoder 'utf8'

sysUtil = require('util')
mongoose = require 'mongoose'
Book = mongoose.model 'Book'
#
# * GET home page.
# 
exports.index = (req, res) ->
	Book.find {}, (err, books) ->
		console.log "error occured when getting all books \n #{err}" if err
		res.render "index", 
			books: books, error: err

exports.lookup = (req, res) ->
	wkt.lookup req.query.word, (message)->
		data = decoder.write(message.data)
		console.log data
		res.json JSON.parse(data)

	