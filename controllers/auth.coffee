passport = require 'passport'

exports.getLogin = (req, res) ->
  res.render 'auth/login', 
    user: req.user
    message: req.session.messages

exports.postLogin = (req, res, next) ->
  passport.authenticate('local', (err, user, info) ->
    return next(err) if err
    unless user
      req.session.messages = [info.message]
      return res.redirect '/login'
    req.logIn user, (err) ->
      return next(err) if err
      res.redirect '/'
  )(req, res, next)

exports.logout = (req, res) ->
  req.logout()
  res.redirect '/'
