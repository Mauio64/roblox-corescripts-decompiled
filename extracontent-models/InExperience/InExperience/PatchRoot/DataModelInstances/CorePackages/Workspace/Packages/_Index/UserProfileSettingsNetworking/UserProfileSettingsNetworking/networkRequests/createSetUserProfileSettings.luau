local parent = script.Parent.Parent
local API_URL = require(parent.API_URL)

return function(p)
	return p.roduxNetworking.POST("SetUserProfileSettings", function(callback, p2)
		return callback(API_URL):path("user-profile-api"):path("v1"):path("user"):path("profiles"):path("settings"):body({
			userProfileSettings = { isInExperienceNameEnabled = p2.isInExperienceNameEnabled }
		})
	end)
end
