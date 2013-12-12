mongoose = require("mongoose")

BookSchema = new mongoose.Schema
	title: String
	pageNum: Number
	author: String

mongoose.model 'Book', BookSchema