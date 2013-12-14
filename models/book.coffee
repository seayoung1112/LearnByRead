mongoose = require("mongoose")

BookSchema = new mongoose.Schema
	title: String
	mainTitle: String
	subTitle: String
	ep: Number
	pageNum: Number
	author: String

mongoose.model 'Book', BookSchema