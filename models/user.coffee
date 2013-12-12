mongoose = require("mongoose")
bcrypt = require('bcrypt')
SALT_WORK_FACTOR = 10

UserSchema = new mongoose.Schema
	email: {type: String, index: true, required: true, unique: true}
	name: {type: String, default: 'anonymous'}
	password: {type: String, required: true}

# Bcrypt middleware
UserSchema.pre 'save', (next) ->
	return next() unless @isModified('password')
	bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) =>
		return next(err) if err
		bcrypt.hash @password, salt, (err, hash) =>
			return next(err) if err
			@password = hash
			next()

# Password verification
UserSchema.methods.comparePassword = (candidatePassword, cb) ->
	bcrypt.compare candidatePassword, this.password, (err, isMatch) ->
		return cb err if err
		cb null, isMatch

mongoose.model 'User', UserSchema