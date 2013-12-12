mongoose = require 'mongoose'
Book = mongoose.model 'Book'
Page = mongoose.model 'Page'

exports.reader = (req, res) ->
	res.render 'book/reader', 
		book: req.params.title
		pageNum: req.params.pageNum

exports.page = (req, res) ->
	Page.find {book: req.params.book, index: req.params.pageNum}, (err, page) ->
		if err
			console.log "error occured when getting page #{req.param.pageNum} of #{req.param.book} \n #{err}"
			return res.json err : err 
		res.json page[0]
