local createGetUserSettings = require("@game/CorePackages/Packages/_Index/NetworkingUserSettings/NetworkingUserSettings/networkRequests/createGetUserSettings")
local createUpdateUserSettings = require("@game/CorePackages/Packages/_Index/NetworkingUserSettings/NetworkingUserSettings/networkRequests/createUpdateUserSettings")

return function(p2)
	return {
		GetUserSettingsPlatform = createGetUserSettings(p2),
		UpdateUserSettingsPlatform = createUpdateUserSettings(p2)
	}
end
