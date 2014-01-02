mongoose = require("mongoose")

AHDWordSchema = new mongoose.Schema
	word: {type: String, trim: true, index: true}
	entries: [
		speech: String
		senses: [
			index: Number
			text: String
		]
	]
, collection: 'AHD'

mongoose.model 'AHDWord', AHDWordSchema