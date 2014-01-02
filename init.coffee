fs = require "fs"
path = require "path"
# init mongoose
mongoose = require "mongoose"
mongoose.connect("mongodb://localhost/learnbyread")

# add all models
model_path = __dirname + '/models'
for model_file in fs.readdirSync model_path
  require path.join(model_path, model_file)

# init wiktionary service
dictionary = require "./services/dictionary"

User = mongoose.model 'User'

#init authentication
passport = require('passport')
LocalStrategy = require('passport-local').Strategy

passport.serializeUser (user, done) ->
  done null, user.id

passport.deserializeUser (id, done) ->
  User.findById id, (err, user) ->
    done err, user

passport.use new LocalStrategy (username, password, done) ->
  User.findOne { name: username }, (err, user) ->
    return done err if err
    return done null, false, message : "Unkonw user #{username}" unless user
    user.comparePassword password, (err, isMatch) ->
      return done err if err
      return if isMatch then done null, user else done null, false, message: 'Invalid password'

exports.ensureAuthenticated = (req, res, next) ->
  return next() if req.isAuthenticated()
  res.redirect '/login'