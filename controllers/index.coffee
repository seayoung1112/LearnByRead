dictionary = require "../services/dictionary"
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
	dictionary.lookup req.query.word, res.lang, (err, wordJson)->
		if err
			console.log "error occured when looking up word \n #{err}"
			return res.json error: err
		res.json wordJson

exports.setLang = (req, res) ->
	lang = req.params.lang
	next = req.query.next or '/'
	if req.user
		req.user.lang = lang
		req.user.save (err) ->
			console.log "error occured when updating user lanuage preference\n #{err}" if err
	req.session.lang = lang
	res.redirect next