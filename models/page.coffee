mongoose = require("mongoose")

PageSchema = new mongoose.Schema
	title: String
	index: Number
	book: String
	sentences: [String]

mongoose.model 'Page', PageSchema