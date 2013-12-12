mongoose = require 'mongoose'
User = mongoose.model 'User'

exports.getRegistration = (req, res) ->
  res.render 'user/registration'

exports.postRegistration = (req, res, next) ->
  User.create {name: req.body.username, email: req.body.email, password: req.body.password}, (err, newUser) ->
  	return next(err) if err
  	req.logIn newUser, (err) ->
      return next(err) if err
      res.redirect '/'