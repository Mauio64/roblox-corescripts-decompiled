local ConnectionUtil = require(script.ConnectionUtil)

return {
	["jest.config"] = script["jest.config"],
	AvatarUtil = require(script.AvatarUtil),
	ConnectionUtil = ConnectionUtil,
	Constants = require(script.Constants),
	Url = require(script.Url),
	SettingsUtility = require(script.SettingsUtility),
	SettingsShowSignal = require(script.SettingsUtility).CreateSignal(),
	MouseIconOverrideService = require(script.MouseIconOverrideService)
}
