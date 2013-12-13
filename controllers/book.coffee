mongoose = require 'mongoose'
Book = mongoose.model 'Book'
Page = mongoose.model 'Page'

exports.reader = (req, res) ->
	Book.find {title: req.params.title}, (err, book) ->
		if err
			console.log "error occured when getting book #{req.param.title} \n #{err}"
			return res.json err : err 
		res.render 'book/reader', 
			book: book[0]
			pageNum: req.params.pageNum

exports.page = (req, res) ->
	Page.find {book: req.params.book, index: req.params.pageNum}, (err, page) ->
		if err
			console.log "error occured when getting page #{req.param.pageNum} of #{req.param.book} \n #{err}"
			return res.json err : err 
		res.json page[0]
