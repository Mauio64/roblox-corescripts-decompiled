require(script.UserSettingsStoreTypes)

local UserSettings = {
	createUserSettingsStore = require(script.createUserSettingsStore),
	getUserSettingsStore = require(script.getUserSettingsStore),
	fetchSettingsAndOptions = 0
}
local userSettingsRequests = require(script.userSettingsRequests)
UserSettings.fetchSettingsAndOptions = userSettingsRequests.fetchSettingsAndOptions
return UserSettings
