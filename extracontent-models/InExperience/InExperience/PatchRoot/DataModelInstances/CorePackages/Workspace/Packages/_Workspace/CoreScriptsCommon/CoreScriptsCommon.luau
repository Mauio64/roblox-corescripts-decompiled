local ConnectionUtil = require(script.ConnectionUtil)

local CoreScriptsCommon = {
	["jest.config"] = script["jest.config"],
	AvatarUtil = require(script.AvatarUtil),
	ConnectionUtil = ConnectionUtil,
	Constants = require(script.Constants),
	Url = require(script.Url),
	SettingsUtility = require(script.SettingsUtility)
}
local SettingsUtility = require(script.SettingsUtility)
CoreScriptsCommon.SettingsShowSignal = SettingsUtility.CreateSignal()
CoreScriptsCommon.MouseIconOverrideService = require(script.MouseIconOverrideService)
return CoreScriptsCommon
