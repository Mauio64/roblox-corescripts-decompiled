local createGetUserProfileSettings = require("@game/CorePackages/Workspace/Packages/_Index/UserProfileSettingsNetworking/UserProfileSettingsNetworking/networkRequests/createGetUserProfileSettings")
local createSetUserProfileSettings = require("@game/CorePackages/Workspace/Packages/_Index/UserProfileSettingsNetworking/UserProfileSettingsNetworking/networkRequests/createSetUserProfileSettings")

return function(p2)
	return { GetUserProfileSettings = createGetUserProfileSettings(p2), SetUserProfileSettings = createSetUserProfileSettings(p2) }
end
