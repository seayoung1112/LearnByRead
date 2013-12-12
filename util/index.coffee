uid = require 'uid2'

exports.generateFilename = (ext='mp3') ->
	uid(24) + '.' + ext