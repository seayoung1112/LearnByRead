
###
Module dependencies.
###
express = require "express"
path = require "path"
http = require "http"
passport = require 'passport'
i18n = require './services/i18n'

app = express()

require('coffee-trace') if "development" is app.get("env")

require "./init"

rootCtrl = require "./controllers"
boardCtrl = require "./controllers/board"
authCtrl = require "./controllers/auth"
userCtrl = require "./controllers/user"
bookCtrl = require "./controllers/book"

# route middleware to ensure user is authenticated.  Otherwise send to login page.
ensureAuthenticated = (req, res, next) ->
	return next() if req.isAuthenticated()
	res.redirect '/login'

# all environments
app.set "port", process.env.PORT or 3000
app.set "views", path.join(__dirname, "views")
app.set "view engine", "jade"

app.use express.compress()
app.use express.favicon()
app.use express.logger("dev")
app.use require('connect-assets')()
app.use require("stylus").middleware(path.join(__dirname, "assets"))
app.use "/", express.static(path.join(__dirname, "assets"))

app.use express.json()
app.use express.urlencoded()
app.use express.cookieParser("asdgdgsewb233ssdf")
app.use express.session()
app.use express.csrf()

# auth
app.use passport.initialize()
app.use passport.session()

# set local varialbes
app.use (req, res, next) ->
	res.locals.csrfToken = req.csrfToken()
	res.locals.user = req.user
	res.locals.originalUrl = req.originalUrl
	next()
#locale
app.use i18n.detect

app.use app.router

# development only
app.use express.errorHandler() if "development" is app.get("env")

# routes started here
app.get "/", rootCtrl.index
app.get "/setlang/:lang", rootCtrl.setLang
app.get "/lookup", rootCtrl.lookup

app.post "/board/add", ensureAuthenticated, boardCtrl.add
app.get "/board", ensureAuthenticated, boardCtrl.show

app.get "/login", authCtrl.getLogin
app.post "/login", authCtrl.postLogin
app.get "/logout", authCtrl.logout

app.get "/registration", userCtrl.getRegistration
app.post "/registration", userCtrl.postRegistration

app.get "/book/:title/page/:pageNum", bookCtrl.reader
app.get "/page/:book/:pageNum", bookCtrl.page

# All partials. This is used by Angular.
app.get "/partials/:name", (req, res) ->
	name = req.params.name
	res.render "partials/" + name

http.createServer(app).listen app.get("port"), ->
	console.log "Express server listening on port " + app.get("port")

