mongoose = require 'mongoose'
Word = mongoose.model 'AHDWord'

exports.lookup = (word, callback) ->
	Word.find {word: word}, (err, result) ->
		return callback err, null if err
		callback null, result[0]