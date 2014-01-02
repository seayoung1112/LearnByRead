wkt = require "./wiktionary"
en_cn = require "./english_chinese"
exports.lookup = (word, lang, callback) ->
	if not word?
		return callback "no word given", null
	if lang in ['en', 'en-US']
		return wkt.lookup word, callback
	if lang in ['cn', 'zh-CN']
		return en_cn.lookup word, callback