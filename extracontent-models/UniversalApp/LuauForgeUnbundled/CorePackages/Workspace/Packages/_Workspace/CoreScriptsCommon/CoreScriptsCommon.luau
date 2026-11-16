local module = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsCommon/CoreScriptsCommon/ConnectionUtil")

return {
	AvatarUtil = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsCommon/CoreScriptsCommon/AvatarUtil"),
	ConnectionUtil = module,
	Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsCommon/CoreScriptsCommon/Constants"),
	Url = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsCommon/CoreScriptsCommon/Url"),
	SettingsUtility = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsCommon/CoreScriptsCommon/SettingsUtility"),
	SettingsShowSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsCommon/CoreScriptsCommon/SettingsUtility").CreateSignal(),
	MouseIconOverrideService = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsCommon/CoreScriptsCommon/MouseIconOverrideService")
}
