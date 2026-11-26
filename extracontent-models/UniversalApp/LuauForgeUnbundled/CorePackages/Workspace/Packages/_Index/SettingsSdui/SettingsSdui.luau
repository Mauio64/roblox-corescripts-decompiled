return {
	SduiSettingsPage = require("@game/CorePackages/Workspace/Packages/_Index/SettingsSdui/SettingsSdui/SduiSettingsPage"),
	fetchSettingsPage = require("@game/CorePackages/Workspace/Packages/_Index/SettingsSdui/SettingsSdui/fetchSettingsPage"),
	SduiUserSettingsRegister = require("@game/CorePackages/Workspace/Packages/_Index/SettingsSdui/SettingsSdui/SduiUserSettingsRegister"),
	registerUserSettingsActions = require("@game/CorePackages/Workspace/Packages/_Index/SettingsSdui/SettingsSdui/registerUserSettingsActions"),
	getSduiUpdateUserSettingsAction = function()
		return require("@game/CorePackages/Workspace/Packages/_Index/SettingsSdui/SettingsSdui/SduiUpdateUserSettingsAction")
	end
}
