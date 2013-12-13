mongoose = require 'mongoose'
UserWord = mongoose.model 'UserWord'

sysUtil = require('util')

exports.show = (req, res) ->
	UserWord.find {user: req.user}, (err, uws) ->
		console.log "error occured when getting all user words \n #{err}" if err
		res.render "board/show", 
			userWords: uws, error: err

# add word to board
exports.add = (req, res) ->
	newWord = 
			user: req.user
			word: req.body.word
			entries: [
				speech: req.body.speech
				senses: [
					index: req.body.sense.index
					gloss:	req.body.sense.content
					examples:[
						content: req.body.sentence
					]
				]
			]

	UserWord.findOne {user: req.user, word: req.body.word}, (err, uw) ->
		if err
			console.log "error occured when finding user word \n #{err}"
			return res.json result: "error", type: "mongo internal", message: err
		if uw
			hasEntry = hasSense = false
			for entry in uw.entries when entry.speech is req.body.speech
				hasEntry = true
				for sense in entry.senses when sense.index is req.body.sense.index
					hasSense = true
					sentences = sense.examples.map (example) -> example.content
					sense.examples.push content: req.body.sentence unless req.body.sentence in sentences
				unless hasSense
					entry.senses.push newWord.entries[0].senses[0]
			unless hasEntry
				uw.entries.push newWord.entries[0]
		else
			uw = new UserWord newWord
		uw.save (err) ->
			if err
				console.log "error occured when saving user word \n #{err} \n input word is : \n #{sysUtil.inspect newWord, depth: null}"
				return res.json result: "error", type: "db operation", message: err
			res.json result:"success", message: "The word \"#{uw.word}\" has been added to your board"