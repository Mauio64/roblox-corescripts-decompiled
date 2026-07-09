local UserSignalTypes = require(script.UserSignalTypes)

return {
	PostSendUserSignal = require(script.PostSendUserSignal),
	UserSignalTypes = UserSignalTypes,
	["jest.config"] = script["jest.config"]
}
