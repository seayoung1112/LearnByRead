en = require '../locale/en-us.json'
cn = require '../locale/zh-cn.json'
dict = en : en, cn : cn, 'en-US' : en, 'zh-CN' : cn

lang = 'en'

t = (key) ->
	res = dict[lang]
	keys = key.split '.'
	for k in keys
		res = res[k]
	return res

exports.detect = (req, res, next) ->
	lang = req.user?.lang or req.session.lang or req.acceptedLanguages[0]
	lang = 'en' if lang not of dict
	res.locals.lang = res.lang = lang
	res.locals.t = t
	next()