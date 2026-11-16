local API_URL = require("@game/CorePackages/Workspace/Packages/_Index/UserProfileSettingsNetworking/UserProfileSettingsNetworking/API_URL")

return function(p2)
	return p2.roduxNetworking.GET("GetUserProfileSettings", function(callback)
		return callback(API_URL):path("user-profile-api"):path("v1"):path("user"):path("profiles"):path("settings")
	end)
end
