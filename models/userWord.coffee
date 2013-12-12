mongoose = require("mongoose")

UserWordSchema = new mongoose.Schema
	user: {type: String, default: 'test', index: true}
	word: {type: String, trim: true, index: true}
	entries: [
		speech: String
		senses: [
			index: {type: Number, index: true}
			gloss: String
			examples: [
				content: {type: String, index: true, required: true}
				createAt: {type: Date, default: Date.now}
			]
		]
	]

mongoose.model 'UserWord', UserWordSchema